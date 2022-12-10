#####################################################################################
#
#   These classes describe objects that define the movement characteristics
#   of a bullet.
#
#   Direction : the class that describes the direction object.
#   Speed     : the class that describes the speed object.
#
#####################################################################################







#####################################################################################
#   Class implementations :
#####################################################################################

#####################################################################################
# The DIRECTION class :
#####################################################################################
class Direction

  attr_accessor :direction, :type

  def initialize(directionElement)

    if directionElement == nil then
      @type       = :aim
      @direction  = "0"
    else
      #-- the direction type : ------------------------------------------------------
      if directionElement.attributes["type"] == nil then
        @type = :aim
      else
        @type = directionElement.attributes["type"].intern
      end

      #-- the direction in degrees : ------------------------------------------------
      @direction = directionElement.text
    end
  end



  ###################################################################################
  #   Returning a COPY of the Direction object :
  ###################################################################################
  def copy

    nd            = Direction.new(nil)          # Creating a new dummy object
    nd.type       = self.type#.clone             # Cloning the type string
    nd.direction  = self.direction.clone        # Cloning the direction string

    nd                                          # Returning the new object

  end

end ### End of the DIRECTION class ##################################################







#####################################################################################
# The SPEED class :
#####################################################################################
class Speed

  attr_accessor :speed, :type

  def initialize(speedElement)

    if speedElement == nil then
      @type   = :absolute
      @speed  = "1.0"
    else
      #-- the speed type : ----------------------------------------------------------
      if speedElement.attributes["type"] == nil then
        @type = :absolute
      else
        @type = speedElement.attributes["type"].intern
      end

      #-- the speed : ---------------------------------------------------------------
      @speed = speedElement.text
    end
  end
  


  ###################################################################################
  #   Returning a COPY of the Speed object :
  ###################################################################################
  def copy

    ns        = Speed.new(nil)          # Creating a new dummy object
    ns.type   = self.type#.clone         # Cloning the type string
    ns.speed  = self.speed.clone        # Cloning the speed string

    ns                                  # Returning the new object

  end

end ### End of the SPEED class ######################################################