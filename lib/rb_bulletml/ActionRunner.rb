################################################################################
#
#   The action object interpreter.
#
#   actionElement : the action object description from the parsed BulletML XML ...
#                   ... parsed file.
#   parent        : the parent object of this action object.
#   source        : the bullet source to which this action belongs.
#   params        : the parameters passed along from the parent.
#
################################################################################







################################################################################
#   The ACTIONRUNNER class :
################################################################################
class ActionRunner

  attr_accessor :x, :y, :direction, :speed, :prevDir, :prevSpeed,
                :dirChanger, :speedChanger, :accelChanger,
                :params, :status, :parent



  ##############################################################################
  # Creating an instance of the action running class :
  ##############################################################################
  def initialize(actionElement, parent, source, params)
    @source       = source                  # The source to which this ...
                                            # ... action belongs to

    # Passing nil as the parent means that this is a top action. Threrefore, ...
    # ... it has some of the caracteristics of bullets.
    if parent == nil then
      @parent     = self
      @x          = @source.x
      @y          = @source.y
      @direction  = @prevDir      = Direction.new(nil)
      @speed      = @prevSpeed    = Speed.new(nil)
    else
      @parent     = parent                  # The parent object of this action
    end

    @elements     = actionElement.elements  # Copy the action elements from ...
                                            # ... the BulletML element to   ...
                                            # ... this object.
                                        
    @element      = 0                       # The first action element to ...
                                            # ... be executed has index 0.

    @repeatAction = nil                     # For now, there is no action to ...
                                            # ... be repeated.

    @step         = 0                       # Waiting, repeating, changing  ...
                                            # ... direction/speed and       ...
                                            # ...accelerating  step         ...
                                            # ... initialization.

    @childAction  = nil                     # The child action this action ...
                                            # ... may embed.
    @child        = false                   # A flag for the child action.
                                            # 0 : no child action
                                            # 1 : child action exists

    @params       = params                  # Storing params for this object.

    @threshold    = 0                       # Threshold for Wait, Repeat,   ...
                                            # ... Accel, changeSpeed and    ...
                                            # ... changeDirection objects.

    @status       = :running                # The action's stats (running,  ...
                                            # waiting, direction and speed  ...
                                            # ... chnage, accelarate or     ...
                                            # ... finished)

  end


  ##############################################################################
  # RUNNING the action object :
  ##############################################################################
  def run

    @x              = @source.x
    @y              = @source.y


    @status         = :running


    currentElement  = @elements[@element]

    case currentElement
    when Wait #---------------------------------------------- Wait -------------
      if @step == 0 then

        # Here, threshold = number of frames to wait :
        @threshold = currentElement.frames.clone
        self.replace(@threshold)                                  # Replacing $rank, $rand...
                                                                  # ... and params.
        @threshold = ExprInterpreter.evaluateString(@threshold)   # Evaluating threshold.

        # Then waiting for first cycle, so doing nothing, but...
        @status = :waiting
        @step+=1                                                  # ... stepping.

      elsif (1..@threshold) === @step then                        # Waiting, so doing nothing, but...
        @status = :waiting
        @step+=1

      else
        @step = 0
        @element+=1

      end


    when Repeat #--------------------------------------------- Repeat ----------
      if @step == 0 then

        # Here, threshold = times the action will have to be repeated :
        @threshold = currentElement.times.clone
        self.replace(@threshold)                                  # Replacing $rank, $rand...
                                                                  # ... and params.
        @threshold = ExprInterpreter.evaluateString(@threshold)   # Evaluating threshold.

        # Then running the first cycle :
        if currentElement.action != nil then
          @repeatAction = ActionRunner.new(currentElement.action, @parent, @source, @params)
        elsif currentElement.actionRef != nil then
          nparams  = []
          currentElement.actionRef.parameters.each { |cp| nparams << cp.clone }
          # Replacing the $x parameters in the next parameters list with ...
          # ... the current parameters list.
          nparams.each do |np|
            self.replace(np)                                # Replacing $rank, $rand...
                                                            # ... and params.
            np = ExprInterpreter.evaluateString(np).to_s    # Evalutating ...
          end
          a = @source.bulletMLSource.actions[currentElement.actionRef.actionLabel]
          @repeatAction = ActionRunner.new(a, @parent, @source, nparams)
        end
        @step+=1

      elsif (1..@threshold) === @step then
        @repeatAction.run
        if @repeatAction.status == :finished then
          @step+=1
          @repeatAction.reset
        elsif @repeatAction.status == :waiting
          @status = :waiting
        end
      else
        @step = 0
        @repeatAction = nil
        @element+=1
      end


    when ChangeDirection then #------------------------------- ChangeDirection -
      @parent.dirChanger =
            DirectionChanger.new(@source, @parent, currentElement, @params)
      @element+=1


    when ChangeSpeed #---------------------------------------- ChangeSpeed -----
      @parent.speedChanger =
            SpeedChanger.new(@source, @parent, currentElement, @params)
      @element+=1


    when Accel #---------------------------------------------- Accel -----------
      @parent.accelChanger =
            AccelChanger.new(@source, @parent, currentElement, @params)
      @element+=1


    when Vanish #--------------------------------------------- Vanish ----------
      @parent.needKill = :yes
      @element+=1


    when Fire #----------------------------------------------- Fire ------------
      @source.addBullet(currentElement, @parent, @params)
      @element+=1


    when FireRef #-------------------------------------------- FireRef ---------
      nparams  = []
      currentElement.parameters.each { |cp| nparams << cp.clone }
      # Replacing the $x parameters in the next parameters list with ...
      # ... the current parameters list. Hum...
      nparams.each do |np|
        self.replace(np)                                # Replacing $rank, $rand...
                                                        # ... and params.
        np = ExprInterpreter.evaluateString(np).to_s    # Evalutating ...
      end
      f = @source.bulletMLSource.fires[currentElement.fireLabel]
      @source.addBullet(f, @parent, nparams)
      @element+=1


    when Action #--------------------------------------------- Action ----------
      if @child == false then
        @child = true
        @childAction = ActionRunner.new(currentElement, @parent, @source, @params)
      else
        @childAction.run
        if @childAction.status == :waiting then
          @status = :waiting
        elsif @childAction.status == :finished
          @child = false
          @childAction = nil
          @element+=1
        end
      end


    when ActionRef #------------------------------------------ ActionRef -------
      if @child == false then
        nparams  = []
        currentElement.parameters.each { |cp| nparams << cp.clone }
        # Replacing the $x parameters in the next parameters list with ...
        # ... the current parameters list. Hum...
        nparams.each do |np|
          self.replace(np)                                # Replacing $rank, $rand...
                                                          # ... and params.
          np = ExprInterpreter.evaluateString(np).to_s    # Evalutating ...
        end
        action = @source.bulletMLSource.actions[currentElement.actionLabel]
        @child = true
        @childAction = ActionRunner.new(action, @parent, @source, nparams)
      else
        @childAction.run
        if @childAction.status == :waiting then
          @status = :waiting
        elsif @childAction.status == :finished
          @child = false
          @childAction = nil
          @element+=1
        end
      end


    else #--------------------------------------------------- Something else ---
      puts "Unknown element " + currentElement.class.to_s
      + " in action element.\n Skipping.\n"
    end


    if @element >= @elements.length then @status = :finished end

  end


  ##############################################################################
  #   Shifting the action's direction :
  ##############################################################################
  def shiftDirection(nd)

    # Computing the shifted direction :
    shiftedDirection = self.direction.direction.to_f + nd

    # Updating the direction object :
    self.direction.direction = shiftedDirection.to_s

  end



  ##############################################################################
  #   Shifting the action's speed :
  ##############################################################################
  def shiftSpeed(ns)

    # Computing the shifted speed :
    shiftedSpeed = self.speed.speed.to_f + ns

    # Updating the speed object :
    self.speed.speed = shiftedSpeed.to_s

  end



  ##############################################################################
  # RESETING the action object :
  ##############################################################################
  def reset
    @element      = 0
    @step         = 0

    @status       = :finished#:waiting#:running
  end



  ##############################################################################
  # Replacing $rank, $rand and params in a string :
  ##############################################################################
  def replace(s)

    # replacing $rank :
    s.gsub!(/\$rank/, @source.rank.to_s)

    # replacing $rand :
    s.gsub!(/\$rand/, rand.to_s)

    # replacing params :
    @params.each_with_index { |p, i| s.gsub!(%r{\$#{i+1}}, p) }

  end

end
