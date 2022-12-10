################################################################################
#
#   These classes define the SOURCE element. This element defines a ...
#   ... bullet source : patern, position, etc ...
#
#   bmlFile           : the BulletML file that describes the shooting patern
#   bulletAppearance  : any parameter describing the bullets appearance
#   position          : relative position in the enemy position
#   shootAgain        : re-fire frequency
#   deadly            : (flag) is the patern deadly or just decoration ?
#   collision         : the collision testing method
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The SOURCE class :
################################################################################
class BulletSourceInfo

  attr_accessor :bmlFile,
                :appearance,
                :x, :y,
                :shootAgain,
                :collision



  def initialize(parentElement, bulletSourceElement)

    @deadly = false

    bulletSourceElement.elements.each do |element|
      case element.name
      when 'bmlFile' then #----------------------------- BulletML file ---------
        @bmlFile = element.text
      when 'bulletAppearance' then #-------------------- bullets' shape --------
        @appearance =
              parentElement.customClasses['bulletAppearance'].new(element)
      when 'position' then #---------------------------- position --------------
        @position = []
        element.elements.each do |p_element|
          case p_element.name
          when 'x' then
            @x = p_element.text.to_i
          when 'y' then
            @y = p_element.text.to_i
          else
            print "Unknown element in <position> element : #{p_element.name}. Skipping.\n"
          end
        end
      when 'shootAgain' then #-------------------------- re-fire frequency -----
        @shootAgain = element.text.to_i
      when 'collision' then #--------------------------- collision -------------
        @collision = Collision.new(element)
      else
        print "Unknown element in <source> element : #{element.name}. Skipping.\n"
      end
    end

  end




  def inspect

    print "BulletML file : #{@bmlFile}\n"
    print "Relative position to enemy : [#{@x},#{@y}]\n"
    print "Shoot again frequency : #{@shootAgain}\n"
    @collision.inspect
    print "Appearance : "
    @bulletAppearance.inspect

  end

end ### End of the SOURCE class ################################################







################################################################################
#   The BULLETAPPEARANCE class :
################################################################################
class BulletAppearance

  def initialize(bulletAppearanceElement)

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the BulletAppearance class been customized yet ?\n"
  end

end ### End of the BULLETAPPEARANCE class ######################################
