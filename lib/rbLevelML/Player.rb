#####################################################################################
#
#   The PLAYER class.
#
#   controller  : the game's controller instance.
#   x, y        : the player's starting position.
#   rank        : the game's difficulty (range from 0 to 1.0).
#   status      : alive, dying or dead ?
#
#####################################################################################







#####################################################################################
#   The PLAYER class :
#####################################################################################
class Player

  attr_accessor :x, :y,
                :rank,
                :collisionType, :collisionZone,
                :status,
                :lives,
                :projectileTypes



  ###################################################################################
  #   CREATING a new instance of the Player class :
  ###################################################################################

  def initialize(controller, x, y, rank, lives)

    @controller               = controller

    @status                   = :alive    # Possible values are : ...
    # ... :alive  -> running normally
    # ... :hit    -> just hit by a bullet or enemy
    # ... :dying  -> things that have to be done before being declared dead
    # ... :dead   -> dead = branch to game over

    @lives                    = lives

    @x                        = x
    @y                        = y
    @vx                       = 0
    @vy                       = 0
    @s                        = 1         # The moving speed.

    @rank                     = rank

    @collisionType            = nil
    @collisionZone            = nil

    @projectileTypes          = []
    @currentProjectileType    = 0

  end





  ###################################################################################
  #   ADDING a PROJECTILE :
  ###################################################################################

  def addProjectileType(projectileInfo)

    @projectileTypes << projectileInfo

  end

  def addProjectile

    # This function has to be implemented by a custom subclass

  end





  ###################################################################################
  #   RESPONDING to external events :
  ###################################################################################

  def eventResponse

    # This function has to be implemented by a custom subclass

  end





  ###################################################################################
  #   RUNNING the player's object :
  ###################################################################################

  def run

    # This function has to be implemented by a custom subclass

  end





  ###################################################################################
  #   DRAWING the player's object :
  ###################################################################################
  def draw

    # This function has to be implemented by a custom subclass

  end





  ###################################################################################
  #   UPDATE STATUS :
  ###################################################################################
  def updateStatus

    case @status
    when :alive then
      # Nothing yet ...

    when :hit then
      @status = :dying # The :dying status is set when the player enters    ...
        # ... an 'agony' state in which it can perform an agony animation.  ...
        # ... Once this animation is finished it switches to :dead status   ...
        # ... which triggers the onDead behavior.

    when :dying then  # A behavior you want to override if you whish to ...
      @status = :dead # ... have a small agonizing animation before the ...
      # ... actual death of the enemy.

    when :dead then
      # Do nothing. The controller will take care of it.

    end

  end

end ### End of the PLAYER class #####################################################
