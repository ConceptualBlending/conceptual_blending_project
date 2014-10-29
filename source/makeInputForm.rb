# This method creates a general input form according to the selected base pattern.
# This method might not be necessary once the formalism of the base pattern is finalized. 
# Since it is not clear yet, this method will use the number of bases from the selected blending pattern to create the general form

def make_Input_Form(input_form)

	#
	if input_form == 2
		inputGeneralForm = { :inputName_1 => "animal_1",	
							:inputClass_1 => "MyAnimal_1",
							:inputURL_1 => "",
							:inputName_2 => "animal_2",
							:inputClass_2 => "MyAnimal_2", 
							:inputURL_2 => "",
							:input_ontology_key => "ontology", 
							:input_class_key => "Class", 
							:inputNameEnd => "=",
							:inputClassSeparate => ":",
							:inputEnd => "end"}
		return inputGeneralForm
	else
		return "No Input" 
	end

end


# MC: the keywords and separators do not depend on the pattern, so they should be elsewhere as constants
