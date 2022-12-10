################################################################################
#
#   These classes define the MOVEMENT element. This element defines how ...
#   ... an enemy moves .
#
#   movement      :  a list of steps
#   movementName  :  a reference name for that movement
#   loop          :  a flag for looping or not
#   moveTo        :  a step
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The MOVEMENT class :
################################################################################
class Movement

  attr_accessor :name,
                :looped,
                :moveTos



  def initialize(movementElement)

    @moveTos  = []
    @looped    = false

    movementElement.elements.each do |element|
      case element.name
      when 'movementName' then
        @name = element.text.intern
      when 'loop' then
        @looped = true
      when 'moveTo' then
        @moveTos << MoveTo.new(element)
      else
        print "Unknown element in <movement> element : #{element.name}. Skipping.\n"
      end
    end

  end



  def inspect

    print " - name : #{@name}\n"
    print " - loop : " + @looped.to_s + "\n"

    @moveTos.each do |m|
      print " - move to "
      m.inspect
    end

  end

end ### End of the MOVEMENT class ##############################################







################################################################################
#   The MOVETO class :
################################################################################
class MoveTo

  attr_accessor :frames,
                :x_slope, :y_slope



  def initialize(moveToElement)

    @coordinates  = []

    x             = 0.0
    y             = 0.0

    moveToElement.elements.each do |element|
      case element.name
      when 'position' then #------------------------- position -----------------
        element.elements.each do |coords|
          case coords.name
          when 'x' then
            x = coords.text.to_f
          when 'y' then
            y = coords.text.to_f
          end
        end
      when 'frames' then #--------------------------- frames -------------------
        @frames = element.text.to_i
      else
        print "Unknown element in <moveTo> element : #{element.name}. Skipping.\n"
      end
    end

    @x_slope = x / frames
    @y_slope = y / frames

  end



  def inspect
    print "[#{@x_slope},#{@y_slope}] for #{@frames} frames.\n"
  end

end ### End of the MOVETO class ################################################
