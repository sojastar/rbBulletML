################################################################################
#
#   These classes define the TIMEFRAME element. This element defines what ...
#   type of enemy enters the screen at what time and where .
#
#   timeframe    :  the timeframe element itself
#   frame        :  a frame element
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The TIMEFRAME class :
################################################################################
class Timeframe

  attr_accessor :frames

  def initialize(parentLevel, timeframeElement)

    @frames       = []

    timeframeElement.elements.each do |element|
      if element.name == 'frame' then
        frame                       = Frame.new(parentLevel, element)
        @frames[frame.frameNumber]  = frame
      else
        print "Unknown element in <timeframe> element : #{element.name}. Skipping.\n"
      end
    end

  end



  def inspect

    @frames.each_index do |i|
      if @frames[i] != nil then
        print "Frame #{i} :\n"
        @frames[i].inspect
      end
    end

  end

end ### End of the TIMEFRAME class #############################################







################################################################################
#   The FRAME class :
################################################################################
class Frame

  attr_accessor :frameNumber,
                :frameAction



  def initialize(parentLevel, frameElement)

    frameElement.elements.each do |element|
      case element.name
      when 'frameNumber' then #------------------------- frame number ----------
        @frameNumber = element.text.to_i
      when 'frameAction' then #------------------------- frame action ----------
        @frameAction = FrameAction.new(parentLevel, element)
      else
        print "Unknown element in <frame> element : #{element.name}. Skipping.\n"
      end
    end

  end



  def inspect

    print " - frame number : #{@frameNumber}\n"
    @frameAction.inspect
    print "\n"

  end

end ### End of the FRAME class #################################################







################################################################################
#   The FRAMEACTION class :
################################################################################
class FrameAction

  attr_accessor :action, :type



  def initialize(parentLevel, frameActionElement)

    frameActionElement.elements.each do |element|
      case element.name
      when 'entry' then #------------------------------------- entry -----------
        @type   = :entry
        @action = EntryAction.new(element)
      when 'killEnemy' then #--------------------------------- kill enemy ------
        @type   = :killEnemy
        @action = element.text.intern
      when 'killPlayer' then #-------------------------------- kill player -----
        @type   = :killPlayer
        @action = nil
      when 'playSound' then #--------------------------------- play sound ------
        @type   = :playSound
        @action = PlaySoundAction.new(element)
      when 'userAction' then #-------------------------------- user action -----
        @type   = :userAction
        @action = parentLevel.customClasses['userDefinedAction'].new(element)
      else
        print "Unknown element in <frameAction> element : #{element.name}. Skipping.\n"
      end
    end

  end





  def inspect

    case @type
    when :entry then
      print " - entry of "
      @action.inspect
    when :killEnemy then
      print " - kill enemy : #{@action}\n"
    when :killPlayer then
      print " - kill player\n"
    when :playSound then
      print " - playing "
      @action.inspect
    when :userAction then
      print " - user defined action. "
    end
  end

end ### End of the FRAMEACTION class ###########################################







################################################################################
#   The ENTRYACTION class :
################################################################################
class EntryAction

  attr_accessor :enemyRef,
                :x0, :y0



  def initialize(entryActionElement)

    entryActionElement.elements.each do |element|
      case element.name
      when 'enemyRef' then #-------------------------- enemy referance ---------
        @enemyRef = element.text.intern
      when 'enemyEntryCoordinates' then #------------- enemy entry coordinates -
        element.elements.each do |coords|
          case coords.name
          when 'x' then
            @x0 = coords.text.to_f
          when 'y' then
            @y0 = coords.text.to_f
          else
            print "Unknown element in <enemyEntryCoordinates> element : #{element.name}. Skipping.\n"
          end
        end
      else
        print "Unknown element in <entry> element : #{element.name}. Skipping.\n"
      end
    end

  end



  def inspect

    print "#{@enemyRef} at coordinates [#{@x0},#{@y0}]\n"

  end

end ### End of the ENTRYACTION class ###########################################







################################################################################
#   The PLAYSOUND class :
################################################################################
class PlaySound

  attr_accessor :soundfile,
                :seconds, :times



  def initialize(playSoundElement)

    @seconds  = -1
    @times    = -1

    playSoundElement.elements.each do |element|
      case element.name
      when 'soundfile' then #------------------------- sound file --------------
        @soundfile = element.text
      when 'seconds' then #--------------------------- seconds -----------------
        @seconds = element.text
      when 'times' then #----------------------------- times -------------------
        @times = element.text
      else
        print "Unknown element in <playSound> element : #{element.name}. Skipping.\n"
      end
    end

  end



  def inspect

    if      (@seconds != -1) and (@times == -1) then
      print "#{@soundfile} for #{@seconds} seconds\n"
    elsif   (@seconds == -1) and (@times != -1) then
      print "#{@soundfile} #{@times} times\n"
    end

  end

end ### End of the FRAME class #################################################







################################################################################
#   The USERDEFINED class :
################################################################################
class UserDefined

  def initialize(userDefined)

    # This function has to be implemented by a custom subclass

  end



  def inspect

    print "Has the UserDefined class been customized yet ?\n"

  end

end ### End of the USERDEFINED class ###########################################
