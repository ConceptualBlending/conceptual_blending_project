# makes base

# ----- base is created using anti-unification technique as used in HDTP (Heuristic-driven Theory Projection)
# ----- In the original HDTP, first-order logic is used as a representation language. 
# ----- In this project, HDTP like system will be developed for OWL.
# ----- This code is subject to change. At the moment it is written using the available data and I have tried to generalize as much as possible but some improvements will take place.


def make_Base(input_General, base_General, morphism_General)
	
	# ----- inputSpace contain the urls of selected input space
	# ----- base_form contains
	# ----- since I have generalize the morphism form already with all the required values, the morphism form can be treated as the final value form ready to be sent to hets. 
	# ----- I am not aware whether morphism are tested by HDTP before it is sent to hets. 
	# ----- Given all of the above, this method returns only what is shared and do not delve into forming morphism.

	shared_objectProperty = ["has_habitat", "has_body_shape", "has_part", "covered_by"]
	shared_Class = ["Mammal", "Hair", "QuadrupedShape", "Tail"]

	return [shared_objectProperty, shared_Class]

end
