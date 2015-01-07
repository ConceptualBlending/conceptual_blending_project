#!/usr/bin/ruby

# this code loops, because the methods do nothing at the moment!

require_relative "selectInputSpaces"
require_relative "findBase"
require_relative "makeInputForHets"
require_relative "createBlend"
require_relative "checkBlendConsistent"
require_relative "weakenInput"
require_relative "checkRequirementSatisfaction"

def create_monsters(inputSpaceRepository, blendRequirement, backgroundKnowledge, blendingPattern)

 # blending pattern currently not used. This is deliberate.
 
 # 1. select input spaces
 # Pradeep
 inputSpace1, inputSpace2 = select_input_spaces(inputSpaceRepository, blendRequirement, backgroundKnowledge)
 blend(inputSpace1, inputSpace2, blendRequirement, backgroundKnowledge)
end

def blend(inputSpace1, inputSpace2, blendRequirement, backgroundKnowledge)
 
 # 2. generic space using anti-unification
 # Raj
 base, morphism1, morphism2 =  generate_base(inputSpace1, inputSpace2)
 # 3. create dol file and run HETS to compute colimit
 # Bhanu
 blendoid = create_blend(base, inputSpace1, inputSpace2, morphism1, morphism2, backgroundKnowledge, blendRequirement)
 # 4. evaluate blend and pass results
 # Bhanu (but this is a bigger task and we need a larger team)
 consistencyResult, conflictSets = consistent_blend?(blendoid, backgroundKnowledge)
 if consistencyResult
   
   requirementResult, missingRequirement = check_requirement_satisfaction(blendoid, blendRequirement)

   if requirementResult == true
     # here we must put the blend somewhere
				
     puts "Blends successfully generated!"
   else # could think of this at a later stage in the project
     puts "Consistent blend, but does not meet the requirements"
   end

 else # 5. weakening
      # Sriram
      weakenedInputSpace1, weakenedInputSpace2 = weaken(inputSpace1, inputSpace2, conflictSets)
      blend(weakenedInputSpace1, weakenedInputSpace2, blendRequirement, backgroundKnowledge)
 end
end

create_monsters("", "", "", "")
