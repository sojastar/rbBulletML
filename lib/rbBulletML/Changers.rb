#####################################################################################
#
#   Objects that run in parallel to a bullet and change its speed, direction ...
#   ... and acceleration.
#
#   DirectionChanger    : changes the direction.
#   SpeedChanger        : changes the speed.
#   AccelChanger        : changes the acceleration.
#
#####################################################################################







#####################################################################################
#   The DIRCHANGER class :
#####################################################################################
class DirectionChanger

  attr_accessor :parent,
                :status



  ###################################################################################
  #   Creating an instance of the DirectionChangerClass class :
  ###################################################################################
  def initialize(source, parent, chgDirElement, params)

    @parent = parent

    # Computing the number of steps for the change :
    t = chgDirElement.term.clone
    
    t.gsub!(/\$rank/, source.rank.to_s)                             # Replacing $rank
    t.gsub!(/\$rand/, rand.to_s)                                    # Replacing $rand
    params.each_with_index { |p, i| t.gsub!(%r{\$#{i+1}}, p) }      # Replacing params

    @term = ExprInterpreter.evaluateString(t)                       # Evaluating term

    # Evaluating the specified direction angle :
    d = chgDirElement.direction.direction.clone
    
    d.gsub!(/\$rank/, source.rank.to_s)                             # Replacing $rank
    d.gsub!(/\$rand/, rand.to_s)                                    # Replacing $rand
    params.each_with_index { |p, i| d.gsub!(%r{\$#{i+1}}, p) }      # Replacing params

    d = ExprInterpreter.evaluateString(d)                           # Evaluating term

    case chgDirElement.direction.type
    when :aim #--------------------------------------------- AIM type : -----
      # Computing the angle (12 o'clock ; bullet to player's position) :
      dx  = source.controller.player.x - @parent.x
      dy  = source.controller.player.y - @parent.y
      a   = Math.atan2(-dx,dy)*57.2957795+180      # 180/3.141592654+180

      d = (d + a - @parent.direction.direction.to_f)%360
      if d > 180 then d -= 360 end
      if d < -180 then d += 360 end
      @dirStep = d / @term

    when :absolute #---------------------------------------- ABSOLUTE type : -
      d = (d - @parent.direction.direction.to_f)%360
      if d > 180 then d -= 360 end
      if d < -180 then d += 360 end
      @dirStep = d / @term

    when :relative
      d=d%360
      if d > 180 then d -= 360 end
      if d < -180 then d += 360 end
      @dirStep = d / @term

    when :sequence #---------------------------------------- SEQUENCE type : -
      @dirStep = d

    else
      print "Problem with the changeDirection's direction type.\n"
    end

    # With the new direction evaluated, we now have to know how

    @parent.shiftDirection(@dirStep)

    @status = :running
    @step = 1

  end



  ###################################################################################
  #   Running the direction changer object :
  ###################################################################################
  def run
    if @status == :running then
      @parent.shiftDirection(@dirStep)
      @step+=1
      if @step >= @term then @status = :finished end
    end
  end

end ### End of the DIRECTIONCHANGER class ###########################################







#####################################################################################
#   The SPEEDCHANGER class :
#####################################################################################
class SpeedChanger

attr_accessor :parent,
              :status



  ###################################################################################
  #   Creating an instance of the SpeedChanger class :
  ###################################################################################
  def initialize(source, parent, chgSpdElement, params)

    @parent = parent

    # Computing the number of steps for the change :
    t = chgSpdElement.term.clone
    
    t.gsub!(/\$rank/, source.rank.to_s)                             # Replacing $rank
    t.gsub!(/\$rand/, rand.to_s)                                    # Replacing $rand
    params.each_with_index { |p, i| t.gsub!(%r{\$#{i+1}}, p) }      # Replacing params

    @term = ExprInterpreter.evaluateString(t)                       # Evaluating term

    # Evaluating the specified speed :
    s = chgSpdElement.speed.speed.clone
    
    s.gsub!(/\$rank/, source.rank.to_s)                             # Replacing $rank
    s.gsub!(/\$rand/, rand.to_s)                                    # Replacing $rand
    params.each_with_index { |p, i| s.gsub!(%r{\$#{i+1}}, p) }      # Replacing params

    s = ExprInterpreter.evaluateString(s)                           # Evaluating term

    case chgSpdElement.speed.type
    when :absolute then
      @speedStep = (s - @parent.speed.speed.to_f) / @term

    when :relative then
      @speedStep = s / @term

    when :sequence then
      @speedStep = s

    else
      print "Problem with the changeSpeed's speed type.\n"
    end

    @parent.shiftSpeed(@speedStep)

    @status = :running
    @step   = 1

  end



  ###################################################################################
  #   Running the speed changer object :
  ###################################################################################
  def run
    if @status == :running then
      @parent.shiftSpeed(@speedStep)
      @step+=1
      if @step >= @term then @status = :finished end
    end
  end

end ### End of the SPEEDCHANGER class ###############################################







#####################################################################################
#   The ACCELCHANGER class :
#####################################################################################
class AccelChanger

  attr_accessor :parent,
                :status



    #################################################################################
    #   Creating an instance of the AccelChanger class :
    #################################################################################
    def initialize(source, parent, accelElement, params)

      @parent = parent


      # Computing the number of steps for the change :
      t = accelElement.term.clone

      t.gsub!(/\$rank/, source.rank.to_s)                             # Replacing $rank
      t.gsub!(/\$rand/, rand.to_s)                                    # Replacing $rand
      params.each_with_index { |p, i| t.gsub!(%r{\$#{i+1}}, p) }      # Replacing params

      @term = ExprInterpreter.evaluateString(t)                       # Evaluating term


      # Taking care of the VERTICAL acceleration :
      if accelElement.vertical != nil then
        v = accelElement.vertical.value.clone

        v.gsub!(/\$rank/, source.rank.to_s)                             # Replacing $rank
        v.gsub!(/\$rand/, rand.to_s)                                    # Replacing $rand
        params.each_with_index { |p, i| v.gsub!(%r{\$#{i+1}}, p) }      # Replacing params

        v = ExprInterpreter.evaluateString(v)                           # Evaluating term

        case accelElement.vertical.type
        when :absolute
          @vAccel = (v - @parent.vy) / @term
        when :relative
          @vAccel = v / @term
        when :sequence
          @vAccel = v
        else
          print "Vertical object has an unknown type\n"
        end
      else
        @vAccel = 0
      end

      # Taking care of the HORIZONTAL acceleration :
      if accelElement.horizontal != nil then
        h = accelElement.horizontal.value.clone

        h.gsub!(/\$rank/, source.rank.to_s)                             # Replacing $rank
        h.gsub!(/\$rand/, rand.to_s)                                    # Replacing $rand
        params.each_with_index { |p, i| h.gsub!(%r{\$#{i+1}}, p) }      # Replacing params

        h = ExprInterpreter.evaluateString(h)                           # Evaluating term

        case accelElement.horizontal.type
        when :absolute
          @hAccel = (h - @parent.vx) / @term
        when :relative
          @hAccel = h / @term
        when :sequence
          @hAccel = h
        else
          print "Horizontal object has an unknown type\n"
        end
      else
        hvAccel = 0
      end

      @parent.shiftAccel(@hAccel, @vAccel)

      @status = :running
      @step = 1

    end



    #################################################################################
    #   Running the speed changer object :
    #################################################################################
    def run
      if @status == :running then
        @parent.shiftAccel(@hAccel, @vAccel)
        @step+=1
        if @step >= @term then @status = :finished end
      end
    end

end ### End of the ACCELCHANGER class ###############################################