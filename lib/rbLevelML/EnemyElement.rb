################################################################################
#
#   This classe defines the ENEMY element.
#
#   name      :  an individual name for an individual enemy entity
#   type      :  the type (pointer to an enemyType) of the enemy
#   movement  :  a list of steps relative to the enemy initial position
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The ENEMY class :
################################################################################
class Enemy

  attr_accessor :name,
                :type,
                :movement



  def initialize(enemyElement)

    enemyElement.elements.each do |element|
      case element.name
      when 'enemyName' then #---------------------------- enemy name -----------
        @name = element.text.intern
      when 'enemyTypeRef' then #------------------------- enemy type reference -
        @type = element.text.intern
      when 'movementRef' then #-------------------------- movement reference ---
        @movement = element.text.intern
      else
        print "Unknown element in <enemy> element : #{element.name}. Skipping.\n"
      end
    end

  end



  def inspect
    print " - name : #{@name} | Type : #{@type} | Movement : #{@movement}\n"
  end

end
