#####################################################################################
#
#   These classes describe the objects that make up an action object
#
#   Wait            : the class that describes the wait object.
#   Repeat          : the class that describes the repeat object.
#   ChangeSpeed     : the class that describes the changeSpeed object.
#   ChangeDirection : the class that describes the changeDirection object.
#   Accel           : the class that describes the accel object.
#   Vanish          : the class that describes the vanish object.
#
#####################################################################################







#####################################################################################
#   Class implementations :
#####################################################################################

#####################################################################################
# The WAIT class :
#####################################################################################
class Wait

  attr_accessor :frames

  def initialize(waitElement)
    @frames = waitElement.text
  end

end







#####################################################################################
# The REPEAT class :
#####################################################################################
class Repeat

  attr_accessor :times, :action, :actionRef

  def initialize(repeatElement, root_bml)

    repeatElement.elements.each do |element|
      case element.name
        when "times" then #--------------------------------------- Times ------------
          @times = element.text
        when "action" then #-------------------------------------- Action -----------
          @action = Action.new(element, root_bml)
          @actionRef = nil
          root_bml.actions[@action.label] = @action
        when "actionRef" then #----------------------------------- ActionRef --------
          @action = nil
          @actionRef = ActionRef.new(element)
        else
          print "Unknown element in repeat element. Skipping.\n"
      end
    end
  end

end







#####################################################################################
# The CHANGEDIRECTION class :
#####################################################################################
class ChangeDirection

  attr_accessor :direction, :term

  def initialize(changeDirectionElement)
    changeDirectionElement.elements.each do |element|
      case element.name
        when "term" then #---------------------------------- Term -------------------
          @term = element.text
        when "direction" then #----------------------------- Direction --------------
          @direction = Direction.new(element)
        else
          print "Unknown element in changeDirection element. Skipping.\n"
      end
    end
  end

end







#####################################################################################
# The CHANGESPEED class :
#####################################################################################
class ChangeSpeed

  attr_accessor :speed, :term

  def initialize(changeSpeedElement)
    changeSpeedElement.elements.each do |element|
      case element.name
        when "term" then #---------------------------------- Term -------------------
          @term = element.text
        when "speed" then #--------------------------------- Speed ------------------
          @speed = Speed.new(element)
        else
          print "Unknown element in changeSpeed element. Skipping.\n"
      end
    end
  end

end







#####################################################################################
# The VANISH class :
#####################################################################################
class Vanish

  attr_accessor :nothing

  def initialize
    @nothing = nil
  end

end







#####################################################################################
# The ACCEL class :
#####################################################################################
class Accel

  attr_accessor :horizontal, :vertical, :term

  def initialize(accelElement)
    accelElement.elements.each do |element|
      case element.name
        when "term" then #---------------------------------- Term -------------------
          @term = element.text
        when "horizontal" then #---------------------------- Horizontal -------------
          @horizontal = Horizontal.new(element)
        when "vertical" then #------------------------------ Vertical ---------------
          @vertical = Vertical.new(element)
        else
          print "Unknown element in accel element. Skipping.\n"
      end
    end
  end

end







#####################################################################################
# The VERTICAL class :
#####################################################################################
class Vertical

  attr_accessor :value, :type

  def initialize(verticalElement)

    #-- the vertical type : ---------------------------------------------------------
    if verticalElement.attributes["type"] == nil then
      @type = :absolute
    else
      @type = verticalElement.attributes["type"].intern
    end

    #-- the vertical value : --------------------------------------------------------
    @value = verticalElement.text

  end

end







#####################################################################################
# The HORIZONTAL class:
#####################################################################################
class Horizontal

  attr_accessor :value, :type

  def initialize(horizontalElement)

    #-- the horizontal type : -------------------------------------------------------
    if horizontalElement.attributes["type"] == nil then
      @type = :absolute
    else
      @type = horizontalElement.attributes["type"].intern
    end

    #-- the horizontal value : ------------------------------------------------------
    @value = horizontalElement.text
  
  end

end
