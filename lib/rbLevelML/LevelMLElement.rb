################################################################################
#
#   These classes describe the main object  of the LevelML part :
#
#   LevelML : the root class
#
################################################################################







################################################################################
#   Includes :
################################################################################

### For the XML parser itself :
require 'rexml/document'
include REXML







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The LEVELML class :
################################################################################
class LevelML

  attr_accessor :customClasses,   # for parsing
                :enemyTypes,
                :movements,

                :controller,      # for playing
                :name,
                :description,
                :status



  ##############################################################################
  #   Creating an instance of the LEVELML class :
  ##############################################################################

  def initialize(controller, customClassesList, filename)

     ### The CONTROLLER that centralize information : ##########################
    @controller     = controller



    ### The list of CUSTOMIZABLE CLASSES that makes up the level : #############
    @customClasses  = Hash.new

    # Default library (abstract) classes :
    @customClasses['background']        = Background
    @customClasses['sound']             = Sound
    @customClasses['miscellaneous']     = Miscellaneous
    @customClasses['enemyAppearance']   = EnemyAppearance
    @customClasses['bulletAppearance']  = BulletAppearance
    @customClasses['onHit']             = OnHit
    @customClasses['onLife']            = OnLife
    @customClasses['onDying']           = OnDying
    @customClasses['onDead']            = OnDead
    @customClasses['userDefined']       = UserDefined

    @customClasses.merge!(customClassesList)



    ### PREPARING the data structures : ########################################
    @enemyTypes     = Hash.new
    @enemies        = Hash.new
    @liveEnemies    = []

    @movements      = Hash.new



    ### OPENING the file : #####################################################
    file = File.new(filename)

    unless file then
      puts "Can't open file " + filename + ". Aborting.\n"
      exit
    end



    ### REXML PARSES the file : ################################################
    doc = REXML::Document.new(file)
    root = doc.root



    ### SCANNING through all the ELEMENTS : ####################################
    root.elements.each do |element|
      case element.name
      when 'name' then #------------------------------------- name -------------
        @name = element.text
      when 'description' then #------------------------------ description ------
        @description = element.text
      when 'enemyType' then #-------------------------------- enemy type -------
        enemyType                   = EnemyType.new(self, element)
        @enemyTypes[enemyType.type] = enemyType
      when 'enemy' then #------------------------------------ enemy ------------
        enemy                       = Enemy.new(element)
        @enemies[enemy.name]        = enemy
      when 'movement' then #--------------------------------- movement ---------
        movement                    = Movement.new(element)
        @movements[movement.name]   = movement
      when 'timeframe' then #-------------------------------- timeframe --------
        @timeframe                  = Timeframe.new(self, element)
      when 'background' then #------------------------------- background -------
        @background                 = @customClasses['background'].new(self, element)
      when 'sound' then #------------------------------------ sound ------------
        @sound                      = @customClasses['sound'].new(self, element)
      when 'miscellaneous' then #---------------------------- miscellenaous ----
        @miscellaneous              = @customClasses['miscellaneous'].new(self, element)
      else
        print "Unknown element found in the <level> element. Skipping.\n"
      end
    end



    ### Other parameters : #####################################################
    @playedFrames = 0
    @status       = :running    # Possible status :
                                # - :running
                                # - :paused
                                # - :finished

  end





  ##############################################################################
  #   ADDING an LIVE ENEMY to the level object :
  ##############################################################################

  def addLiveEnemy(x, y, name)

    # If using a custom LiveEnemy subclass, you have to overide this function ...
    # ... so that it uses the custom subclass creator.

    # The default LiveEnemy class :
    @liveEnemies << LiveEnemy.new(self, x, y, @enemies[name])

  end





  ##############################################################################
  #   RUNNING the level object :
  ##############################################################################

  def run

    case @status
    when :running then # The most common case : RUNNING the level : ############
    ############################################################################

      # Reading the timeframe for possible actions to take : ###################

      if @timeframe.frames[@playedFrames] != nil then

        f = @timeframe.frames[@playedFrames]

        case f.frameAction.type
        when :entry then
          addLiveEnemy(f.frameAction.action.x0,
                       f.frameAction.action.y0,
                       f.frameAction.action.enemyRef)

        when :killEnemy then
          @liveEnemies.delete_if do |e| e.name == f.action end

        when :killPlayer then
          @controller.player.status = :dying

        when :playSound then
          playSound(f.action)

        when :userAction then
          handleUserAction

        end

      end

      # Running the enemies : ##################################################

      # Running all enemies :
      @liveEnemies.each do |e|
        e.run
      end


      # Everything else : ######################################################

      # Everything else (like background update or scrolling, music change, ...
      # ... etc) will have to be taken care of in a custom class.

      # AT THE END ALWAYS :
      @playedFrames+=1



    #when :paused then # When paused, don't do anything : #######################
    ############################################################################



    #when :finished then # When finished, move to the next level : ##############
    ############################################################################

    end

  end





  ##############################################################################
  #   Playing a SOUND :
  ##############################################################################

  def playSound(playSoundAction)
    # This function has to be implemented by a custom subclass
  end





  ##############################################################################
  #   Handling USER DEFINED ACTIONS :
  ##############################################################################

  def handleUserAction(userAction)
    # This function has to be implemented by a custom subclass
  end





  ##############################################################################
  #   DRAWING the level objects :
  ##############################################################################

  def draw

    @liveEnemies.each do |e|
      e.draw
    end

  end





  ##############################################################################
  #   STATUS UPDATE :
  ##############################################################################
  def updateStatus

    
    @liveEnemies.each do |e|
      e.updateStatus
    end


    # Cleaning out the dead enemies :
    @liveEnemies.delete_if do |e|
      e.status == :dead
    end


    # Are all enemies dead ?
    if @liveEnemies == [] then @status = :finishing end


    # Finishing behavior :
    if @status == :finishing then @status = :finished end # A behavior you  ...
    # ... want to override if you whish to have a small closing animation   ...
    # ... before moving on to the next level.

  end





  ##############################################################################
  #   RESETING :
  ##############################################################################

  def reset
    @playedFrames = 0
    @liveEnemies.clear
    @status = :running
  end





  ##############################################################################
  #   PRINTING the level object in an humanly readable format :
  ##############################################################################

  def inspect

    print "\nName : #{@name}\n"
    print "Description : #{@description}\n"

    print "\nEnemy types : ------------------------------------------------------------------\n"
    i = 1
    @enemyTypes.each do |t|
      print "Enemy type #{i} :\n"
      t.inspect
      i+=1
    end

    print "\nEnemies : ----------------------------------------------------------------------\n"
    i = 1
    @enemies.each do |e|
      print "Enemy #{i} :\n"
      e.inspect
      i+=1
    end

    print "\nMovements : --------------------------------------------------------------------\n"
    i = 1
    @movements.each do |m|
      print "Movement #{i} :\n"
      m.inspect
    end

    print "\nTimeframe : --------------------------------------------------------------------\n"
    @timeframe.inspect

    if @background != nil then
      print "\nBackground : -------------------------------------------------------------------\n"
      @background.inspect
    end

    if @background != nil then
      print "\nSound : ------------------------------------------------------------------------\n"
      @sound.inspect
    end

    if @background != nil then
      print "\nMiscellenaous : ----------------------------------------------------------------\n"
      @miscellenaous.inspect
    end

  end

end ### End of the LEVEL class #################################################
