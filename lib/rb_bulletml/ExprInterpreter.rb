#####################################################################################
#
#   A module with tools to evaluate arithmetic strings with +-*/% and any ...
#   ... level of parenthesis.
#
#####################################################################################







#####################################################################################
#   The EXPRINTERPRETER module :
#####################################################################################
module ExprInterpreter


  #####################################################################################
  #   Evaluating any arithmetic string made of +-*/%() :
  #####################################################################################
  def ExprInterpreter.evaluateString(e)

    tockens = e.scan(/\d+\.*\d*|[-+*\/%()]/)    # the string is split in tockens

    ### Finding parenthesis pairs : ###################################################
    while (i=tockens.index(")")) != nil do  # The first ')' we find should logically ...
                                            # ... be the deepest ')', so let's loop  ...
                                            # ... through the first ')'.

      parenthesisTockens = tockens.slice(0, i)  # Cutting the tocken array just before ...
                                                # ... the ')'

      j = parenthesisTockens.rindex("(")        # Starting from the end of the array  ...
                                                # ... the first '(' we find should be ...
                                                # the opening '(' of our current ')'.

      # Let's evaluate what is between the parenthesis ...
      tockens[j] = ExprInterpreter.evaluateTockens(tockens.slice(j+1, i-j-1))

      # ... and store the result in our tocken array, than clean the array.
      tockens.fill(nil, j+1, i-j)
      tockens.compact!
    end

    ExprInterpreter.evaluateTockens(tockens)  # evaluating the now parenthesis free ...
                                              # arithmetic tockens array.

  end



  #####################################################################################
  #   Evaluating a array of tockens without parenthesis :
  #####################################################################################
  def ExprInterpreter.evaluateTockens(t)

    ### Taking care of an eventual minus sign : #######################################
    if t[0] == "-" then     # Is the first token a minus sign ?

      t[0]+=t[1]            # If yes, than change the second token, logically a ...
                            # ... number, to a negative number.

      t[1] = nil            # Then clean up the removed minus token ...

      t.compact!            # ... and clean up the token array.
    end

    ### Evaluating modulos : ##########################################################
    while (i = t.index("%")) != nil do      # Finding each modulo tockens.

      t[i-1] = t[i-1].to_f % t[i+1].to_f    # Computing the modulo and storing ...
                                            # ... the results in the tocken array.

      t[i] = t[i+1] = nil                   # Cleaning the array.

      t.compact!                            # Finish the cleaning.
    end

    ### Evaluating multiplications : ##################################################
    while (i = t.index("*")) != nil do
      t[i-1] = t[i-1].to_f * t[i+1].to_f
      t[i] = t[i+1] = nil
      t.compact!
      #puts t
    end

    ### Evaluating divisions : ########################################################
    while (i = t.index("/")) != nil do
      t[i-1] = t[i-1].to_f / t[i+1].to_f
      t[i] = t[i+1] = nil
      t.compact!
    end

    ### We now only deal with a sequence of additions and substraction : #############
    stack = t.shift.to_f
    while t != [] do
      op  = t.shift
      f   = t.shift.to_f
      if op == "+" then
        stack+=f.to_f
      elsif op == "-" then
        stack-=f.to_f
      end 
    end

    stack

  end

end
