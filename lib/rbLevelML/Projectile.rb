################################################################################
#
#   The PROJECTILE class.
#
#   controller    : the game's controller instance.
#   x, y          : the projectile's starting position.
#   vx, vy        : speed along both axes
#   collisionType : radial or mask ?
#   collisionZone : a radius or some masking data
#   damage        : damage
#
################################################################################







################################################################################
#   The PROJECTILE class :
################################################################################
class Projectile

  attr_accessor :x, :y,
                :collisionType, :collisionZone,
                :damage,
                :status



  ##############################################################################
  #   CREATING a new projectile instance :
  ##############################################################################
  def initialize(controller, x, y, projectileInfo)

    @controller     = controller

    @status         = :alive

    @x              = x
    @y              = y

    @vx             = projectileInfo['vx']
    @vy             = projectileInfo['vy']

    @collisionType  = projectileInfo['collisionType']
    @collisionZone  = projectileInfo['collisionZone']

    @damage         = projectileInfo['damage']

    # But you can add any other key => element couple to the projectileInfo ...
    # ... hash to customize you projectile.

  end





  ##############################################################################
  #   RUNNING a projectile instance :
  ##############################################################################
  def run

    case @status
    when :alive then
      @x+=@vx
      @y+=@vy
    when :dying
      # Nothing yet
    end

  end





  ##############################################################################
  #   DRAWING a projectile instance :
  ##############################################################################
  def draw
    # This function has to be implemented by a custom subclass
  end





  ##############################################################################
  #   STATUS UPDATE :
  ##############################################################################
  def updateStatus

    case @status
    when :alive then
      # Nothing yet ...

    when :hit then
      @status = :dying # The :dying status is set when the projectile enters...
        # ... an 'agony' state in which it can perform an agony animation.  ...
        # ... Once this animation is finished it switches to :dead status   ...
        # ... which triggers the onDead behavior.

    when :dying then  # A behavior you want to override if you whish to ...
      @status = :dead # ... have a small agonizing animation before the ...
      # ... actual death of the enemy.

    when :dead then
      # Do nothing. The controller will take care of it.

    end

    return @status

  end

end ### End of the PROJECTILE class ############################################
