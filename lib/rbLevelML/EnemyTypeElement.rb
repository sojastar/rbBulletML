################################################################################
#
#   These classes define the ENEMYTYPE element. An enemy is a group of ...
#   ... positioned bullet sources, appearance, collision, durability,  ...
#   ... movement and other parameters .
#
#   type          : a string identifying the enemy type
#   description   : a short text describing the enemy
#   sourcesInfo   : the BulletML objects that describes the shooting patern
#   appearance    : any parameter describing the bullets appearance
#   collision     : relative position in the enemy position
#   lifePoints    : re-fire frequency
#   onHit         : what the enemy does when hit
#   onLife        :  what the enemy does when its life points reache ...
#                    ... a certain amount
#   onDead        : what the enemy does when it dies
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The ENEMYTYPE class :
################################################################################
class EnemyType

  attr_accessor :type,
                :description,
                :sourcesInfo,
                :appearance,
                :collision,
                :lifePoints,
                :onHit, :onLife, :onDeath



  def initialize(parentElement, enemyTypeElement)

    @sourcesInfo  = []

    enemyTypeElement.elements.each do |element|
      case element.name
      when 'typeName' then #--------------------------------- type name --------
        @type = element.text.intern
      when 'description' then #------------------------------ description  -----
        @description = element.text
      when 'bulletSourceInfo' then #------------------------- list of sources --
        @sourcesInfo << BulletSourceInfo.new(parentElement, element)
      when 'enemyAppearance' then #-------------------------- appearance -------
        @appearance =
              parentElement.customClasses['enemyAppearance'].new(element)
      when 'collision' then #-------------------------------- collision --------
        @collision = Collision.new(element)
      when 'lifePoints' then #------------------------------- life points ------
        @lifePoints = element.text.to_i
      when 'onHit' then #------------------------------------ hit behavior  ----
        @onHit    = parentElement.customClasses['onHit'].new(element)
      when 'onLife' then #----------------------------------- life % behavior  -
        @OnLife   = parentElement.customClasses['onLife'].new(element)
      when 'onDying' then #---------------------------------- dying behavior  --
        @onDying  = parentElement.customClasses['onDying'].new(element)
      when 'onDead' then #----------------------------------- death behavior  --
        @onDead   = parentElement.customClasses['onDead'].new(element)
      else
        print "Unknown element in <enemyType> element : #{element.name}. Skipping.\n"
      end
    end

  end





  def inspect

    print " - type : #{@type}\n"
    print " - descritpion : #{@description}\n"

    print " - sources :\n"
    @sourcesInfo.each_index do |i|
      s = " --- Source #{i} : ---\n"
      print s
      @sourcesInfo[i].inspect
      s.length.times do print '-' end
      print "\n"
    end

    print " - appearance : "
    @enemyAppearance.inspect

    print " - collision "
    @collision.inspect

    print " - life points : #{@lifePoints}\n"

    print " - actions :\n"
    @onHit.inspect
    @OnLife.inspect
    @onDying.inspect
    @onDead.inspect

  end

end ### End of the ENEMY class #################################################







################################################################################
#   The ENEMYAPPEARANCE class :
################################################################################
class EnemyAppearance

  def initialize(enemyAppearanceElement)

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the EnemyAppearance class been customized yet ?\n"
  end

end ### End of the ENEMYAPPEARANCE class #######################################







################################################################################
#   The ONHIT class :
################################################################################
class OnHit

  def initialize(onHitElement)

    # This function has to be implemented by a custom subclass

  end

  def run

    # This function has to be implemented by a custom subclass

  end

  def draw

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the OnHit class been customized yet ?\n"
  end

end ### End of the ONHIT class #################################################







################################################################################
#   The ONLIFE class :
################################################################################
class OnLife

  attr_accessor :life

  def initialize(onLifeElement)

    # This function has to be implemented by a custom subclass

  end

  def run

    # This function has to be implemented by a custom subclass

  end

  def draw

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the OnLife class been customized yet ?\n"
  end

end ### End of the ONLIFE class ################################################







################################################################################
#   The ONLIFE class :
################################################################################
class OnDying

  def initialize(onDyingElement)

    # This function has to be implemented by a custom subclass

  end

  def run

    # This function has to be implemented by a custom subclass

  end

  def draw

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the OnDying class been customized yet ?\n"
  end

end ### End of the ONLIFE class ################################################







################################################################################
#   The ONDEAD class :
################################################################################
class OnDead

  def initialize(onDeadElement)

    # This function has to be implemented by a custom subclass

  end

  def run

    # This function has to be implemented by a custom subclass

  end

  def draw

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the OnDead class been customized yet ?\n"
  end

end ### End of the ONDEAD class ################################################
