#####################################################################################
#
#   The bullet object interpreter.
#
#   fireElement : the fire element that is the source for the bullet.
#   parent      : the parent object of this action object.
#   source      : the bullet source to which this action belongs.
#   params      : the parameters passed along from the parent.
#
#####################################################################################







#####################################################################################
#   The BULLETRUNNER class :
#####################################################################################
class BulletRunner


  attr_accessor :x, :y, :vx, :vy, :direction, :speed, :prevDir, :prevSpeed,
                :dirChanger, :speedChanger, :accelChanger,
                :needKill



  ###################################################################################
  #   Creating an instance of the bullet running class :
  ###################################################################################
  def initialize(fireElement, parent, source, params)
    
    @source       = source      # The bullet source this bullet belongs to
    @parent       = parent      # The parent of this bullet

    @dirChanger   = nil         # An object running in parallel to the bullet object ...
                                # This object changes the bullet's direction over time.

    @speedChanger = nil         # An object running in parallel to the bullet object ...
                                # This object changes the bullet's speed over time.

    @accelChanger = nil         # An object running in parallel to the bullet object ...
                                # This object changes the bullet's vertical and ...
                                # ... horizontal speed over time.


    # Before anything is done the fire object's direction and speed have ...
    # ... evaluated against the current set of parameters, because those ...
    # ... parameters may later be modified in case a bulletRef object is ...
    # ... present.
    #################################################################################
    if fireElement.direction != nil then
      fdir = fireElement.direction.copy
      fdir.direction.gsub!(/\$rank/, @source.rank.to_s)
      fdir.direction.gsub!(/\$rand/, rand.to_s)
      params.each_with_index { |p, i| fdir.direction.gsub!(%r{\$#{i+1}}, p) }
    end

    if fireElement.speed != nil then
      fspeed = fireElement.speed.copy
      fspeed.speed.gsub!(/\$rank/, @source.rank.to_s)
      fspeed.speed.gsub!(/\$rand/, rand.to_s)
      params.each_with_index { |p, i| fspeed.speed.gsub!(%r{\$#{i+1}}, p) }
    end


    # What does the fireElement fires? A bullet or a bulletRef ?
    #################################################################################
    if fireElement.bullet != nil then #------------------------------- BULLET : -----
      bullet  = fireElement.bullet
      @params = params
    else #------------------------------------------------------------ BULLETREF : --
      # Retrieving the referenced bullet object :
      bullet = source.bulletMLSource.bullets[fireElement.bulletRef.bulletLabel]

      # In case of a bulletRef, the bulletRef parameters have to be evaluated ...
      # ... against the fire parameters. This is why we have to evaluate the  ...
      # ... fire's direction and speed before.
      @params = []
      fireElement.bulletRef.parameters.each { |p| @params << p.clone }
      @params.each do |np|
        np.gsub!(/\$rank/, @source.rank.to_s)
        np.gsub!(/\$rand/, rand.to_s)
        params.each_with_index { |p, i| np.gsub!(%r{\$#{i+1}}, p) }
      end
    end


    # Was the direction specified in the fire tag or is it included in the bullet tag ?
    # It looks from the Aba Games BulletML demo applet that the direction in the fire ...
    # ... tag always overrules the one in the bullet tag.
    # If there is no direction specified in either objects, we just create a new one.
    ###################################################################################
    if fireElement.direction != nil then
      @direction = fdir
    elsif (bullet.direction != nil) and (fireElement.direction == nil) then
      @direction = bullet.direction.copy
    else
      @direction = Direction.new(nil)
    end


    # Same thing for the speed :
    if fireElement.speed != nil then
      @speed = fspeed
    elsif (bullet.speed != nil) and (fireElement.speed == nil) then
      @speed = bullet.speed.copy
    else
      @speed = Speed.new(nil)
    end


    # The bullet starting position is the current parent bullet position :
    #################################################################################
    @x = @parent.x
    @y = @parent.y

    # I'm not sure if this is really necessary ...
    #################################################################################
    @prevDir = Direction.new(nil)#@parent.prevDir
    @prevSpeed = Speed.new(nil)#@parent.prevSpeed


    ### Evaluating the ABSOLUTE DIRECTION of the bullet from the direction type : ###
    #################################################################################

    # First, let's EVALUATE the @direction.DIRECTION ARITHMETIC STRING :          ### 
    #################################################################################

    # Replacing the parameters with their value :
    @params.each_with_index do |e, i|
      paramRegExp = %r{\$#{i+1}}
      @direction.direction.gsub!(paramRegExp, @params[i])
    end

    # Replacing the $rank parameter with its value :
    @direction.direction.gsub!(/\$rank/, @source.rank.to_s)

    # Replacing the $rand parameter by a random value in the [0.0;1.0] range :
    @direction.direction.gsub!(/\$rand/, rand.to_s)

    # Evaluating the direction string :
    d = ExprInterpreter.evaluateString(@direction.direction)


    # Then, compute the final absolute value (in degrees) of the DIRECTION ...  #####
    # ... according to the direction type :                                     #####
    #################################################################################
    case @direction.type
    when :aim #------------------------------------------- AIM type : --------------

      # Computing the angle (12 o'clock ; bullet to player's position) :
      # The game controller's player class has to provide both ...
      # ... an 'x' and a 'y' attribute readers.
      dx  = @source.controller.player.x - @x
      dy  = @source.controller.player.y - @y
      a   = Math.atan2(-dx,dy)*57.2957795+180      # 180/3.141592654+180

      # Computing the final angle :

      # For now, let's store the direction as a float, not as a string anymore ...
      # ... because we will need it for later computation. We'll convert it    ...
      # ... back as a string after the all computations are done.
      @direction.direction = d + a

    when :absolute #-------------------------------------- ABSOLUTE type : ---------
      @direction.direction = d

    when :relative #-------------------------------------- RELATIVE type : ---------

      # For the relative direction type, the angle specified by the direction object ...
      # ... is to be added to the angle of this bullet parent object.
      rd = parent.direction.direction

      @direction.direction = d + ExprInterpreter.evaluateString(rd)

    when :sequence #-------------------------------------- SEQUENCE type : ---------

      # For the sequence direction type, the angle specified by the direction object ...
      # ... is to be added to the angle of the previously shot bullet, which we      ...
      # ... always save in the source direction object (a few more lines down).
      sd = @parent.prevDir.direction

      @direction.direction = d + ExprInterpreter.evaluateString(sd)

    else
      print "Direction attribute has to be either aim, absolute, relative or sequence.\n"
      print "Found : " + @direction.type.to_s + " of type " + @direction.type.class.to_s + "\n"

    end

    # The final value will is an absolute value so :
    @direction.type = :absolute


    ### Evaluating the ABSOLUTE SPEED of the bullet from the speed type : ###########
    #################################################################################

    ### First, let's evaluate the @speed.speed arithmetic string :          #########
    #################################################################################
    @params.each_with_index do |e, i|
      paramRegExp = %r{\$#{i+1}}
      @speed.speed.gsub!(paramRegExp, @params[i])
    end

    # Replacing the $rank parameter with its value :
    @speed.speed.gsub!(/\$rank/, @source.rank.to_s)

    # Replacing the $rand parameter by a random value in the [0.0;1.0] range :
    @speed.speed.gsub!(/\$rand/, rand.to_s)

    # Evaluating the speed string :
    s = ExprInterpreter.evaluateString(@speed.speed)


    # Then, compute the final absolute value of the speed according to the ...  #####
    # ... speed type :                                                          #####
    #################################################################################
    case @speed.type
    when :absolute #-------------------------------------- ABSOLUTE type : ---------
      @speed.speed = s

    when :relative #-------------------------------------- RELATIVE type : ---------

      # For the relative speed type, the speed specified by the speed object ...
      # ... is to be added to the speed of this bullet parent object.
      rs = @parent.speed.speed

      @speed.speed = s + ExprInterpreter.evaluateString(rs)

    when :sequence #-------------------------------------- SEQUENCE type : ---------

      # For the sequence speed type, the speed specified by the speed object is ...
      # ... to be added to the speed of the previously shot bullet, which we    ...
      # ... always save in the source speed object (a few more lines down).
      ss = @parent.prevSpeed.speed

      @speed.speed = s + ExprInterpreter.evaluateString(ss)

    else
      print "Speed attribute has to be either aim, absolute, relative or sequence.\n"

    end

    # The final value is an absolute value so :
    @speed.type = :absolute


    # Computing the bullet's x and y offset :
    @vx = @speed.speed*Math.sin(@direction.direction*0.01745329252)
    @vy = -@speed.speed*Math.cos(@direction.direction*0.01745329252)


    ### COMPUTATIONS are FINISHED so we can : #######################################
    @direction.direction  = @direction.direction.to_s  # Converting the direction back ...
                                                       # ... to a string.
    @parent.prevDir = @direction.copy                  # Then copy it to the source ...
                                                       # ... for 'sequence' firing.

    ### SAME thing for the SPEED : ##################################################
    @speed.speed  = @speed.speed.to_s
    @parent.prevSpeed = @speed.copy


    ### PREPARING the bullet's ACTIONS, if necessary : ##############################
    @actions = []
    bullet.actions.each do |a|
      if a.class.to_s == "Action"
        @actions << ActionRunner.new(a, self, @source, @params)

      elsif a.class.to_s == "ActionRef"
        nparams = []
        a.parameters.each { |cp| nparams << cp.clone }
        # Replacing the $x parameters in the next parameters list with ...
        # ... the current parameters list :
        nparams.each_with_index do |np, i|
          self.replace(np)                                # Replacing $rank, $rand...
                                                          # ... and params.
          np = ExprInterpreter.evaluateString(np).to_s    # Evalutating ...
        end

        ra = @source.bulletMLSource.actions[a.actionLabel]
        @actions << ActionRunner.new(ra, self, @source, nparams)
      end
    end

    ### The bullet's kill flag is turned off : ######################################
    @needKill = "no"

  end



  ###################################################################################
  #   MOVING the bullet and RUNNING it's ACTION :
  ###################################################################################
  def run

    ### Running the bullet's action : ##############################################
    @actions.each do |a|

      actionStatus = :running
      while actionStatus == :running do

        a.run
        actionStatus = a.status

        break if actionStatus == :finished
      end

    end

    @actions.delete_if { |a| a.status == :finished }     # Removing the finished actions

    ### Running the bullet's changers : ############################################
    @dirChanger.run   unless @dirChanger   == nil
    @speedChanger.run unless @speedChanger == nil
    @accelChanger.run unless @accelChanger == nil

    ### Moving : ###################################################################
    @x+=@vx#*@source.scaling
    @y+=@vy#*@source.scaling

    ### If the bullet runs out of the frame, destroy it : ##########################
    unless (0..@source.controller.width)  === @x  then    # On the sides ?
      @needKill = :yes
      return
    end

    unless (0..@source.controller.height) === @y  then    # From the top or bottom ?
      @needKill = :yes
      return
    end

  end



  ###################################################################################
  #   Shifting the bullet's direction and updating the x and y offsets ...
  #   ... accordingly :
  ###################################################################################
  def shiftDirection(nd)
    
    # Computing the shifted direction :
    shiftedDirection = self.direction.direction.to_f + nd

    # Updating the bullet's x and y offset :
    speed = @speed.speed.to_f
    @vx = speed*Trigo.sin(shiftedDirection)
    @vy = -speed*Trigo.cos(shiftedDirection)

    # Updating the direction object :
    self.direction.direction = shiftedDirection.to_s

  end



  ###################################################################################
  #   Shifting the bullet's speed and updating the x and y offsets ...
  #   ... accordingly :
  ###################################################################################
  def shiftSpeed(ns)

    # Computing the shifted speed :
    shiftedSpeed = self.speed.speed.to_f + ns

    # Updating the bullet's x and y offset :
    direction = @direction.direction.to_f
    @vx = shiftedSpeed*Trigo.sin(direction)
    @vy = -shiftedSpeed*Trigo.cos(direction)

    # Updating the speed object :
    self.speed.speed = shiftedSpeed.to_s

  end



  ###################################################################################
  #   Shifting the bullet's vertical and horizontal speeds :
  ###################################################################################
  def shiftAccel(h, v)

    # Shifting the bullet's x and y offset :
    @vx+=h
    @vy+=v

    # Updating the speed and direction object :

    # Computing the direction :
    a = Math.atan2(-@vx,@vy)
    @direction.direction = (a*57.2957795+180).to_s
    @direction.type = :absolute

    # Computing the speed :
    s = Math.hypot(@vx,@vy)
    @speed.type = :absolute

  end



  ###################################################################################
  #   DRAWING the bullet :
  ###################################################################################
  def draw
    # This function has to be implemented by a custom subclass
  end
  


  ###################################################################################
  # Replacing $rank, $rand and params in a string :
  ###################################################################################
  def replace(s)

    # replacing $rank :
    s.gsub!(/\$rank/, @source.rank.to_s)

    # replacing $rand :
    s.gsub!(/\$rand/, rand.to_s)

    # replacing params :
    @params.each_with_index { |p, i| s.gsub!(%r{\$#{i+1}}, p) }

  end

end