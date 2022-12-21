#####################################################################################
#
#   These classes describe the main objects :
#
#   BulletML  : the root class
#   Bullet    : the class that describes the bullet object.
#   Fire      : the class that describes the fire object.
#   Action    : the class that describes the action object.
#
#####################################################################################





################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The BULLETML class :
################################################################################
module BulletML
  class Pattern
    attr_accessor :data,
                  :bullets, :fires, :actions, :top_actions
  
  
  
    ###################################################################################
    #   Creating the BulletML object :
    #
    #   filename : the text file to be parsed
    #
    ###################################################################################
    def initialize(filename)
      
      #@bullets    = Hash.new
      #@fires      = Hash.new
      #@actions    = Hash.new
      #@topActions = []

      @data       = $gtk.args.gtk.parse_xml_file(filename).fetch(:children).first
      clean_up(@data)

      #@action     = scan_data_for(:action)
  
      #parseBulletMLFile(filename)
  
      #@actions.each_key do |k|
      #  if k =~ /top/ then
      #    @topActions << @actions[k]
      #  end
      #end
  
      #if @topActions == [] then
      #  print "There is no top labeled action. Aborting.\n"
      #  exit
      #end
  
    end

    def clean_up(element)
      if element[:type] == :content
        element[:data]  = element[:data].to_f

      else
        element[:name]        = element[:name].to_sym unless element[:name].nil?
        element[:attributes]  = element[:attributes].each_pair
                                                    .map { |n,v| [n.to_sym, v.to_sym] }
                                                    .to_h
        element[:children].each { |c| clean_up c }
      end
    end

    def scan_pattern_for(type)
    end
  end
end



  ###################################################################################
  #   Parsing a BulletML XML file and storing it in the BulletML object :
  ###################################################################################
#  def parseBulletMLFile(filename)
#
#    ### OPENING the file : ##########################################################
#    file = File.new(filename)
#
#    unless file then
#      puts "File " + filename + "does not exist. Aborting.\n"
#      exit
#    end
#
#
#
#    ### REXML PARSES the file : #####################################################
#    doc = Document.new file
#    root = doc.root
#
#
#
#    ### STORING the parsed data : ###################################################
#
#    ### Is this a VERTICAL or an HORIZONTAL shooter ?
#    @type = root.attributes["type"]
#    if @type == nil
#      @type = "vertical"
#    end
#
#
#
#    ### SCANNING through all the ELEMENTS : ########################################
#    root.elements.each do |element|
#
#      #-- Retrieving the LABEL : ---------------------------------------------------
#      l = element.attributes["label"]
#
#      #-- SORTING the top level ACTIONS, FIRES and BULLETS : -----------------------
#      case element.name
#        when "action" then #------------------------------------- Actions ----------
#          if l == nil then
#            l = "action_label" + @actions.length.to_s
#          end
#          @actions[l] = Action.new(element, self)
#        when "fire" then #--------------------------------------- Fires ------------
#          if l == nil then
#            l = "fire_label" + @fires.length.to_s
#          end
#          @fires[l] = Fire.new(element, self)
#        when "bullet" then #------------------------------------- Bullets ----------
#          if l == nil then
#            l = "bullet_label" + @bullets.length.to_s
#          end
#          @bullets[l] = Bullet.new(element, self)
#        else
#          print "Unknown element found in <bulletml> element : #{element.name}. Skipping.\n"
#      end
#    end
#
#  end
#
#end ### End of the BULLETML class ###################################################







#####################################################################################
# The BULLET class :
#####################################################################################
#class Bullet
#
#  attr_accessor :label, :direction, :speed, :actions
#
#  def initialize(bulletElement, root_bml)
#
#    ### Does the bullt object have a label ? ########################################
#    @label = bulletElement.attributes["label"]
#    if @label == nil then
#      @label = "autolabeled_bullet" + root_bml.bullets.length.to_s
#    end
#
#    ### Scanning through all the elements : #########################################
#    
#    @actions = []                                     # Preparing the actions array
#
#    bulletElement.elements.each do |element|          # Actually scanning
#      case element.name
#        when "direction" then #----------------------------- Direction --------------
#          @direction = Direction.new(element)
#        when "speed" then #--------------------------------- Speed ------------------
#          @speed = Speed.new(element)
#        when "action" then #-------------------------------- Action -----------------
#          @actions << Action.new(element, root_bml)
#          root_bml.actions[@actions.last.label] = @actions.last
#        when "actionRef" then #----------------------------- ActionRef --------------
#          @actions << ActionRef.new(element)
#        else
#          print "Unknown element found in <bullet> element : #{element.name}. Skipping.\n"
#      end
#    end
#
#  end
#
#end ### End of the BULLET class #####################################################
#
#
#
#
#
#
#
######################################################################################
## The FIRE class :
######################################################################################
#class Fire
#
#  attr_accessor :label, :direction, :speed, :bullet, :bulletRef
#
#  def initialize(fireElement, root_bml)
#
#    ### Does the fire object have a label ? #########################################
#    @label = fireElement.attributes["label"]
#    if @label == nil then
#      @label = "autolabeled_fire" + root_bml.fires.length.to_s
#    end
#
#    ### Scanning through all the elements : #########################################
#    fireElement.elements.each do |element|
#      case element.name
#        when "direction" then #----------------------------- Direction --------------
#          @direction = Direction.new(element)
#        when "speed" then #--------------------------------- Speed ------------------
#          @speed = Speed.new(element)
#        when "bullet" then #-------------------------------- Bullet -----------------
#          @bullet = Bullet.new(element, root_bml)
#          @bulletRef = nil
#          root_bml.bullets[@bullet.label] = @bullet
#        when "bulletRef" then #----------------------------- BulletRef --------------
#          @bullet = nil
#          @bulletRef = BulletRef.new(element)
#        else
#          print "Unknown element found in <fire> element : #{element.name}. Skipping.\n"
#      end
#    end
#
#    if (@bullet == nil) and (@bulletRef == nil)
#      print "No bullet or bulletRef element in <fire> element\nAborting.\n"
#      exit
#    end
#
#  end
#
#end ### End of the FIRE class #######################################################
#
#
#
#
#
#
#
######################################################################################
## The ACTION class :
######################################################################################
#class Action
#
#  attr_accessor :label, :elements
#
#  ###################################################################################
#  # Creating the action object
#  ###################################################################################
#
#  def initialize(actionElement, root_bml)
#    @elements = []
#
#    ### Does the action object have a label ? #######################################
#    @label = actionElement.attributes["label"]
#    if @label == nil then
#      @label = "autolabeled_action" + root_bml.actions.length.to_s
#    end
#
#    ### Scanning through all the elements : #########################################
#    actionElement.elements.each do |element|
#      case element.name
#        when "wait" then #------------------------------------ Wait -----------------
#          @elements << Wait.new(element)
#        when "repeat" then #---------------------------------- Repeat ---------------
#          @elements << Repeat.new(element, root_bml)
#        when "changeSpeed" then #----------------------------- ChangeSpeed ----------
#          @elements << ChangeSpeed.new(element)
#        when "changeDirection" then #------------------------- ChangeDirection ------
#          @elements << ChangeDirection.new(element)
#        when "accel" then #----------------------------------- Accel ----------------
#          @elements << Accel.new(element)
#        when "vanish" then #---------------------------------- Vanish ---------------
#          @elements << Vanish.new
#        when "fire" then #------------------------------------ Fire -----------------
#          f = Fire.new(element, root_bml)
#          @elements << f
#          root_bml.fires[f.label] = f
#        when "fireRef" then #--------------------------------- FireRef --------------
#          @elements << FireRef.new(element)
#        when "action" then #---------------------------------- Action ---------------
#          a = Action.new(element, root_bml)
#          @elements << a
#          root_bml.actions[a.label] = a
#        when "actionRef" then #------------------------------- ActionRef ------------
#          @elements << ActionRef.new(element)
#        else
#          print "Unknown element found in <action> element : #{element.name}. Skipping.\n"
#      end
#    end
#
#  end
#
#end ### End of the ACTION class #####################################################
