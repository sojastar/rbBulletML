#####################################################################################
#
#   A source of bullets.
#
#   controller  : the game's controller class.
#   x, y        : position of the source in the game's frame.
#   file_name   : the name of the BulletML XML file describing the patern for
#                 this bullet source.
#
#####################################################################################







#####################################################################################
#   The BULLETSOURCE class :
#####################################################################################
class BulletSource

  attr_accessor :x, :y,
                :scaling,
                :rank,
                :liveBullets, :controller, :bulletMLSource,
                :prevDir, :prevSpeed



  ###################################################################################
  #   Creating an instance of the bullet source class :
  ###################################################################################
  def initialize(controller, x, y, bulletMLSource)
    @controller       = controller        # the game's controller


    ### Movement : ##################################################################
    @x                = x                 # horizontal position of the source
    @y                = y                 # vertical position of the source

    #@scaling          = 1.0               # scaling factor

    @rank = @controller.player.rank       # the difficulty rate


    ### Connecting to a BulletML object : ###########################################
    @bulletMLSource   = bulletMLSource

    ### ... and then preparing it's top actions to be runned :
    @topActions       = []
    @bulletMLSource.topActions.each do |ta|
      @topActions << ActionRunner.new(ta, nil, self, [])
    end
    @finishedActions  = 0


    ### Others : ####################################################################
    @liveBullets      = []                # creating the bullets' storing array

  end



  def addBullet(fireElement, parent, params)
    
    # If using a custom BulletRunner subclass, you have to overide this function ...
    # ... so that it uses the custom subclass creator.

    # The default BulletRunner class :
    @liveBullets << BulletRunner.new(fireElement, parent, self, params)

  end



  ###################################################################################
  #   RUNNING the source top action and bullets :
  ###################################################################################
  def run

    ### Running the top action in a loop : ##########################################
    if @finishedActions < @topActions.length then

      @topActions.each do |ta|

        topActionStatus = :running
        while topActionStatus == :running do
          ta.run
          topActionStatus = ta.status

          if topActionStatus == :finished then
            ta.reset                      # Resetting the top action ...
            @finishedActions+=1
            break
          end
        end
      end

    end

    ### Running the bullets the source created : ###################################
    @liveBullets.each do |b| b.run end                    # Running the bullets    ...

        
    @liveBullets.delete_if do |b| b.needKill == :yes end  # ... and removing those ...
                                                          # ... which vanished or  ...
                                                          # ... left the screen.

  end



  ###################################################################################
  #   RESETING the source :
  ###################################################################################
  def reset

    @topActions.each do |ta|              # reseting all top actions
      ta.reset
    end
    @finishedActions  = 0

  end



  ###################################################################################
  #   DRAWING all the source's bullets :
  ###################################################################################
  def draw

    # If you want the source to have a representation on the screen, you have ...
    # ... to implement that behavior in a custom subclass.

    ### Drawing all the bullets belonging to the source : ###########################
    @liveBullets.each do |b|
      b.draw
    end

  end



  ###################################################################################
  #   MOVING the source :
  ###################################################################################
  def move(x, y)

    @x = x
    @y = y

  end

end
