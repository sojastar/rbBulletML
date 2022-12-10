################################################################################
#
#   This classes define the LIVEENEMY element. 
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The LIVEENEMY class :
################################################################################
class LiveEnemy

  attr_accessor :name,
                :x, :y,
                :status



  ##############################################################################
  #   Creating an instance of the LIVEENEMY class :
  ##############################################################################

  def initialize(parentLevel, x, y, enemy)

    @parentLevel    = parentLevel
    @controller     = parentLevel.controller

    @name           = enemy.name
    @type           = enemy.type

    @x              = x
    @y              = y

    @status         = :alive

    @lifePoints     = @parentLevel.enemyTypes[enemy.type].lifePoints

    @appearance     = @parentLevel.enemyTypes[enemy.type].appearance

    @onHit          = @parentLevel.enemyTypes[enemy.type].onHit

    #-- Sources : --------------------------------------------------------------

    @sources        = []
    @parentLevel.enemyTypes[@type].sourcesInfo.each do |info|
      addLiveBulletSource(info)
    end

    #-- End of Sources ---------------------------------------------------------


    #-- Movement : -------------------------------------------------------------

    @movement       = @parentLevel.movements[enemy.movement]
    @currentMoveTo  = 0
    @moveToFrames   = 0

    #-- End of Movement --------------------------------------------------------


    #-- Collisions : -----------------------------------------------------------

    @collisionType  = @parentLevel.enemyTypes[enemy.type].collision.type
    @collisionZone  = @parentLevel.enemyTypes[enemy.type].collision.zone

    #-- End of Collisions ------------------------------------------------------

    # The rest of this function will have to be customized to suit   ...
    # ... particular needs, like : parameters for the different      ...
    # ... possible actions (onHit, onLife, onDead), parameters for   ...
    # ... the draw function (appearance), parameters for the bullets ...
    # ... draw function, etc ... 

  end





  ##############################################################################
  #   ADDING a bullet source to the enemy object :
  ##############################################################################

  def addLiveBulletSource(sourceInfo)

    # This function will have to be overidden and customized if you use ...
    # ... a customized LiveBulletSource class.

    @sources << LiveBulletSource.new(@controller,
                                     @x+sourceInfo.x,
                                     @y+sourceInfo.y,
                                     sourceInfo)

  end





  ##############################################################################
  #   RUNNING the enemy object :
  ##############################################################################

  def run

    if (@status == :alive) | (@status == :hit) then

      ### Actions : ############################################################

      if @status == :hit then
        @onHit.run
        #@status = :alive
      end

      ### Move : ###############################################################

      if @moveToFrames < @movement.moveTos[@currentMoveTo].frames then # If ...
      # ... we are in a moveTo, just compute the next (x;y) values and add  ...
      # ... them to the last position.

        @x+=@movement.moveTos[@currentMoveTo].x_slope
        @y+=@movement.moveTos[@currentMoveTo].y_slope

        @sources.each do |s|
          s.move(@x, @y)
        end

        @moveToFrames+=1

      else # IF we reached the last moveTo frame, reset all variables and ...
      # ... go to the nex moveTo.

        @moveToFrames = 0

        @currentMoveTo+=1

        if @currentMoveTo == @movement.moveTos.length then # Have we reached  ...
        # ... the end of the moveTos list ? If yes and the movement is looped ...
        # ... then we reset both @moveToFrames and @currentMoveTo. If not,    ...
        # ... we make @moveToFrames strictly higher than :                    ...
        # ... @movement.moveTos[@currentMoveTo].frames so the first test is   ...
        # ... always false. A bit tricky, but it works.

          if @movement.looped == true
            @currentMoveTo = 0
          else
            @currentMoveTo-=1
            @moveToFrames = @movement.moveTos[@currentMoveTo].frames + 2
          end

        end

      end

      ### Shoot : ##############################################################

      @sources.each do |s| s.run end


      ### Collision : ##########################################################

      didHitPlayer?
      collisionWithPlayer?
      collisionWithProjectiles?


    elsif @status == :dying then
      if @onDyingAction != nil then @onDyingAction.run end


    elsif @status == :dead then
      if @onDeadAction != nil then @onDeadAction.run end

    end

  end





  ##############################################################################
  #   COLLISION MATTERS :
  ##############################################################################

  ##############################################################################
  #   Testing collisions with the player's shots :
  ##############################################################################

  def collisionWithProjectiles?

    # This function has to be implemented by a custom subclass

  end





  ##############################################################################
  #   Testing collision with the player itself :
  ##############################################################################

  def collisionWithPlayer?

    # This function has to be implemented by a custom subclass

  end





  ##############################################################################
  #   Testing collisions between the enemy's bullets and the player :
  ##############################################################################

  def didHitPlayer?

    # This function has to be implemented by a custom subclass

  end





  ##############################################################################
  #   DRAWING :
  ##############################################################################

  def draw

    @sources.each do |s|
      s.draw
    end

  end





  ##############################################################################
  #   STATUS UPDATE :
  ##############################################################################
  def updateStatus

    case @status
    when :alive then
      if @lifePoints <= 0 then @status = :dying end

    when :hit then
      if @lifePoints <= 0 then
        @status = :dying # The :dying status is set when the enemy enters   ...
        # ... an 'agony' state in which it can perform an agony animation.  ...
        # ... Once this animation is finished it switches to :dead status   ...
        # ... which triggers the onDead behavior.
      else
        @status = :alive
      end

    when :dying then  # A behavior you want to override if you whish to ...
      @status = :dead # ... have a small agonizing animation before the ...
      # ... actual death of the enemy.

    end

  end





  ##############################################################################
  #   Printing the enemy's data in a humanly readable form :
  ##############################################################################

  def inspect

    print "Enemy #{@name} of type #{@type} at [#{@x},#{@y}] :\n"

    print " - movement reference : #{@movement.name}\n"

    case @status
    when :alive then  print " - status : alive\n"
    when :hit   then  print " - status : hit\n"
    when :dying then  print " - status : dying\n"
    when :dead  then  print " - status : dead\n"
    else              print " - status : unknown status type\n"
    end

    print " - life points : #{@lifePoints}\n"

  end

end