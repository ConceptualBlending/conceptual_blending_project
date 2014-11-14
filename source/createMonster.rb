#!/usr/bin/ruby

# note: do not run this code, it is not yet finished

require 'open3'
require 'io/wait'


def show_message(msg)

	puts msg

end


def begin_process

	# the process select_blend_pattern is not applicable, since we are focusing only on one pattern. But for future work, this method is applicable.
	# blendPattern = select_blend_pattern(blendPatternRepository, blendRequirement, backgroundKnowledge)
	
	# note: inputSpace_1, inputSpace_2 are objects of class Ontology
	# inputSpace_1, inputSpace_2 = select_input_spaces(blendPattern, inputSpaceRepository, blendRequirement, backgroundKnowledge)
	
	inputSpace_1, inputSpace_2 = select_input_spaces(inputSpaceRepository, blendRequirement, backgroundKnowledge)
		
	#create_monsters(blendPattern, inputSpace_1, inputSpace_2, blendRequirement, backgroundKnowledge) 		# expected call

	create_monsters(inputSpace_1, inputSpace_2, blendRequirement, backgroundKnowledge) 						# current call
end




def create_monsters(inputSpace_1, inputSpace_2, blendRequirement, backgroundKnowledge)

	base, morphism_1, morphism_2 = find_base(inputSpace_1, inputSpace_2)

	inputForBlend = make_input_for_hets(inputSpace_1, inputSpace_2, backgroundKnowledge, base, morphism_1, morphism_2)

	blendResult = create_blend(inputForBlend)
	
	make_evaluation(blendResult, backgroundKnowledge, blendRequirement)

end





def make_evaluation(blendResult, backgroundKnowledge, blendRequirement, inputSpace_1, inputSpace_2)

	consistencyResult = check_blend_consistent(blendResult, backgroundKnowledge)

		if consistencyResult == true
		
		requirementResult, missingRequirement = check_requirement_satisfaction(blendResult, blendRequirement)

		if requirementResult == true
				
			show_result("Blends successfully generated!!")

		else
			
			show_result("Blend does not satisfy requirements. The requirements not satisfied are: " + missingRequirement)

		end

			
	else			

		weakenInputSpace_1, weakenInputSpace_2 = weaken_input(inputSpace_1, inputSpace_2)

		create_monsters(weakenInputSpace_1, weakenInputSpace_2, blendRequirement, backgroundKnowledge)	

	end


end
