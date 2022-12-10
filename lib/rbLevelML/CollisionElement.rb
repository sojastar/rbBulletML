################################################################################
#
#   These classes define the COLLISION element. This element defines the ...
#   ... shape of a bullet or enemy collision zone .
#
#   radius  :  the zone is a circle and this is its radius (in pixel)
#   alpha   :  (flag) use the alpha channel of the appearance data ?
#   mask    :  the zone is defined by a mask stored in a graphic file
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The COLLISION class :
################################################################################
class Collision

  attr_accessor :type,
                :zone



  def initialize(collisionElement)

    @alpha = false

    collisionElement.elements.each do |element|
      case element.name
      when 'radius' then #----------------------------- radius -----------------
        @type = :radius
        @zone = element.text.to_i
      when 'mask' then #------------------------------- mask -------------------
        @type = :mask
        @zone = loadMaskBitmap(element.text)
      else
        print "Unknown element in <collision> element : #{element.name}. Skipping.\n"
      end
    end
  end



  def loadMaskBitmap(maskfile)
    # Not really implemented yet ...
    @zone = maskfile
  end



  def inspect
    case @type
    when :radius then
      print "radius : #{@zone}\n"
    when :mask then
      print "mask (not really implemented yet) : #{@zone}\n"
    end
  end

end ### End of the COLLISION class #############################################
