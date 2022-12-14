#####################################################################################
#
#   Math trigonometrical class that relies on fixed pre-calculated values.
#
#####################################################################################







#####################################################################################
#   The TRIGO class :
#####################################################################################
module Trigo


  ###################################################################################
  #   CREATING the Trigo object :
  ###################################################################################
  def Trigo.initialize(steps = 360)

    @@sin  = []
    @@cos  = []
    @@atan = []

    steps.times do |a|
      @@sin[a] = Math.sin(a*0.01745329252)
      @@cos[a] = Math.cos(a*0.01745329252)
    end

  end

  def Trigo.sin(a)
    @@sin[(a+0.5).to_i%360]
  end

  def Trigo.cos(a)
    @@cos[(a+0.5).to_i%360]
  end

end