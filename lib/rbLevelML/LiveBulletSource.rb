################################################################################
#
#   This classes define the LIVE_BULLET_SOURCE element. 
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The LIVE_BULLET_SOURCE class :
################################################################################
class LiveBulletSource  < BulletSource

  attr_accessor :x0, :y0,
                :collisionType, :collisionZone



  ##############################################################################
  #   Creating an instance of the LIVE_BULLET_SOURCE class :
  ##############################################################################
  def initialize(controller, x, y, sourceInfo)

    ############################################################################
    # Initializing everything like in a standard rubybulletml BulletSource ... #
    # ... but with a few more things that rubylevelml requires.                #
    ############################################################################

    # The offset position from the parent enemy position :
    @x0 = sourceInfo.x
    @y0 = sourceInfo.y


    # The regular rubybulletml BulletSource initialization :
    super(controller,
          x + @x0,
          y + @y0,
          BulletML.new(sourceInfo.bmlFile))


    # The bullets appearance information :
    @appearance = sourceInfo.appearance


    # The re-fire information :
    @shootAgain = sourceInfo.shootAgain
    @frames     = 1


    # Collision information :
    @collisionType  = sourceInfo.collision.type
    @collisionZone  = sourceInfo.collision.zone

  end





  ##############################################################################
  #   RUNNING the LiveBulletSource instance :
  ##############################################################################
  def run

    # Running the LiveBulletSource as a regular rubybulletml BulletSource ...
    super

    # But LiveBulletSources can reset themselves to fire again :
    if @frames % @shootAgain == 0 then
      @frames = 0
      self.reset
    end

    @frames+=1

  end





  ##############################################################################
  #   MOVING the LiveBulletSource instance :
  ##############################################################################
  def move(x, y)

    # This time around, moving implies not forgetting the offset from the ...
    # ... parent enemy position :
    @x = @x0 + x
    @y = @y0 + y

  end

end
