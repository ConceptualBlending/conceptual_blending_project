# This method creates a general morphism form according to the selected base pattern.
# This method might not be necessary once the formalism of the base pattern is finalized. 
# Since it is not clear yet, this method will use the number of morphism forms from the selected blending pattern to create the general form


def make_Morphism_Form(morphism_form, input_General, base_General)

	if morphism_form == 2
		morphismGeneralForm = { :morphismName_1 => "animalMorphism1", 
								:name_map_1 => "#{base_General[:base_name]} to #{input_General[:inputName_1]}", 
								:class_map_1 => "#{base_General[:base_class]} |-> #{input_General[:inputClass_1]}", 
								:morphismName_2 => "animalMorphism2", 
								:name_map_2 => "#{base_General[:base_name]} to #{input_General[:inputName_2]}", 
								:class_map_2 => "#{base_General[:base_class]} |-> #{input_General[:inputClass_2]}",
								:morphism => "interpretation",
								:morphismNameEnd => ":",
								:morphismMapEnd => "=" }
		return morphismGeneralForm
	else
		return "No Morphism" 
	end


end

# MC: it is possible that we are going to use morphisms for other purposes in the application
# MC: so therefore it is more convenient to store the pairs (Organism, Horse)
# MC: instead of the string "Organism |-> Horse"

# interpretation hoti12Horse: hoti1 to horse  =
#	Organism |-> Horse 

# interpretation hoti12Tiger: hoti1 to tiger  =
#	Organism |-> Tiger
