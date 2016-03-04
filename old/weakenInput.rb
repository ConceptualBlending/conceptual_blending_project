# ------ This method weakens the input spaces if the blendoid inconsistent

# we need as arguments:
# the input spaces
# the blend
# the morphisms from the input spaces to the blend
# the background knowledge
# the symbol that was given by the consistency checker in the reason
# for inconsistency


def weaken(inputSpace_1, inputSpace_2, mor1, mor2, blend, bgKnow, confSym)
 
 # 1. one method that takes as arguments bgKnow, blend and confSym
 #    and returns a set of symbols
 # let S be initially the set with {confSym}
 # repeat
 #   look for sentences in bgKnow and in blend
 #   that use a symbol in S 
 #   add all their symbols to S
 # until S stays unmodified (no new symbols were found)
 # return S as result

 # 2. one method that takes as input a morphism and a set of symbols S
 # and gives as result the set of all symbols X of the source signature of the morphism
 # such that the result of applying the symbol_map of the morphism to X is
 # an element in S

 # 3. one method that takes as input a set of symbols S and an ontology
 # and returns the list of all sentences that use at least one symbol from S
 # and the list of all sentences that don't use symbols from S

 # 4. the main function:
  # a. call the first function for bkKnow, blend and confSym
  # b. save the result in S
  # c. remove from S all symbols that are not in the signature of blend
  # d. call the second method for mor1 and S, save result in S1
  # e. call the second method for mor2 and S, save result in S2
  # f. call the third method for S1 and inputSpace_1, save the result in (l11, l12)
  # g. call the third method for S2 and inputSpace_2, save the result in (l21, l22)
  # h. let onto1 be the ontology  
  #     with same signature as inputSpace_1 
  # and with sentences: l12 + deleteRandomElementFrom(l11)
  # and
  #    let onto2 be the ontology  
  #     with same signature as inputSpace_2 
  # and with sentences: l22 + deleteRandomElementFrom(l21)
  # i. return onto1 and onto2 as results
  # restrict the set of relevant symbols to those that appear in the blend


  # Comment for Mihai:they should also be published so that we have a valid URL for them

 
end
