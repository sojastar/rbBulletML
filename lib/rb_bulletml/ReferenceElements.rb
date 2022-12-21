#####################################################################################
#
#   These classes describe the objects that are references to bullet, fire,
#   and action label.
#
#   BulletRef : the class that describes the bulletRef object.
#   FireRef   : the class that describes the fireRef object.
#   ActionRef : the class that describes the actionRef object.
#
#####################################################################################







#####################################################################################
#   Class implementations :
#####################################################################################

#####################################################################################
# The BULLETREF class :
#####################################################################################
class BulletRef

  attr_accessor :bulletLabel, :parameters

  def initialize(bulletRefElement)
    @parameters = []

    #-- The REFERENCED OBJECT's LABEL : ---------------------------------------------
    @bulletLabel = bulletRefElement.attributes["label"]

    #-- Storing the PARAMETERS : ----------------------------------------------------
    bulletRefElement.elements.each do |param|
      @parameters << param.text
    end
  end

end







#####################################################################################
# The FIREREF class :
#####################################################################################
class FireRef

  attr_accessor :fireLabel, :parameters

  def initialize(fireRefElement)
    @parameters = []

    #-- The REFERENCED OBJECT's LABEL : ---------------------------------------------
    @fireLabel = fireRefElement.attributes["label"]

    #-- Storing the PARAMETERS : ----------------------------------------------------
    fireRefElement.elements.each do |param|
      @parameters << param.text
    end
  end

end







#####################################################################################
# The ACTIONREF class :
#####################################################################################
class ActionRef

  attr_accessor :actionLabel, :parameters

  def initialize(actionRefElement)
    @parameters = []

    #-- The REFERENCED OBJECT's LABEL : ---------------------------------------------
    @actionLabel = actionRefElement.attributes["label"]

    #-- Storing the PARAMETERS : ----------------------------------------------------
    actionRefElement.elements.each do |param|
      @parameters << param.text
    end
  end

end