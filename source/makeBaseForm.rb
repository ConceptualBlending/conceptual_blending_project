
# This method creates a general base form according to the selected base pattern.
# This method might not be necessary once the formalism of the base pattern is finalized. 
# Since it is not clear yet, this method will use the number of bases from the selected blending pattern to create the general form

def make_Base_Form(base_form)

	#
	if base_form == 1
		baseGeneralForm = { :base_ontology_key => "ontology",
							:base_name => "monster_base",
							:base_class_key => "Class", 
							:base_class => "Monster", 
							:base_end => "end", 
							:base_name_end => "=",
							:base_class_separate => ":"}
		return baseGeneralForm
	else
		return "No Base" 
	end

end

#MC: constants...


