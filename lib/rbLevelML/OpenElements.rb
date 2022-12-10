################################################################################
#
#   These classes describe important objects that are left open for user design.
#
#   background  :   the things that might make up the background ( images, ...
#                   ... videos, program parameters, even code for Ruby )
#   sound       :   the things that might make up the sound ( sound files,
#                   etc ... )
#
################################################################################







################################################################################
#   Class implementations :
################################################################################

################################################################################
#   The BACKGROUND class :
################################################################################
class Background

  attr_accessor :parentLevel



  def initialize(parentLevel, backgroundElement)

    @parentLevel  = parentLevel

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the Background class been customized yet ?\n"
  end

end ### End of the BACKGROUND class ############################################







################################################################################
#   The SOUND class :
################################################################################
class Sound

  attr_accessor :parentLevel



  def initialize(parentLevel, soundElement)

    @parentLevel  = parentLevel

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the Sound class been customized yet ?\n"
  end

end ### End of the SOUND class #################################################







################################################################################
#   The MISCELLANEOUS class :
################################################################################
class Miscellaneous

  attr_accessor :parentLevel



  def initialize(parentLevel, miscellenaousElement)

    @parentLevel  = parentLevel

    # This function has to be implemented by a custom subclass

  end

  def inspect
    print "Has the Miscellenaous class been customized yet ?\n"
  end

end ### End of the MISCELLANEOUS class #########################################
