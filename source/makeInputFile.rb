
require_relative 'makeBKForm'
require_relative "makeSharedStructureForm"
require_relative "makeBase"
require_relative "makeBlendoidForm"
require_relative "makeEvaluationQuery"

	# ----- This method create the necesary input file for hets
	# ----- This make_input_method is developed only for v-pattern blending pattern. To incorporate more complex blending pattern, the below code needs to be improved.

def make_Input_File(input_General, base_General, morphism_General, bk_repository, sharedStructureForm, sharedObjectProperty, sharedClass)

	dest = File.open('input.dol', 'w') #{|file| file.truncate(0) }
	

	dest.puts "logic OWL" 

	dest.puts ""
	dest.puts ""
	# ----- writing input spaces
	# 		input_General = { :inputName_1 => "animal_1",	
	#						:inputClass_1 => "MyAnimal_1",
	#						:inputURL_1 => "",
	#						:inputName_2 => "animal_2",
	#						:inputClass_2 => "MyAnimal_2", 
	#						:inputURL_2 => "",
	#						:input_ontology_key => "ontology",
	#						:input_class_key => "Class", 
	#						:inputNameEnd => "=",
	#						:inputClassSeparate => ":"
	#						:inputEnd => "end"}
	# ----- write input space 1 to input.dol
	dest.puts "#{input_General[:input_ontology_key]} #{input_General[:inputName_1]} #{input_General[:inputNameEnd]}"
	dest.puts "#{input_General[:input_class_key]}#{input_General[:inputClassSeparate]} #{input_General[:inputClass_1]}"
	dest.puts "<#{input_General[:inputURL_1]}>"
	dest.puts "#{input_General[:inputEnd]}"

         #MC: this is not valid DOL
         #MC:   ontology animal_1 = 
         #MC:     Class: My_Animal1
         #MC:     <some_url>
         #MC:   end
         #MC: could be written like
         #MC:  ontology animal_1  = 
         #MC:    <some_url>
         #MC:   then
         #MC:    Class: My_Animal1
         #MC: but you don't want to do this anyways
         #MC: what you want is to say which is the class from <some_url> 
         #MC: where Monster is mapped to, so you can write the interpretations
         #MC: for the moment, it can be set by a method to the constant Horse 

	dest.puts ""
	#dest.puts "%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	dest.puts ""

	# ----- write input space 2 to input.dol
	dest.puts "#{input_General[:input_ontology_key]} #{input_General[:inputName_2]} #{input_General[:inputNameEnd]}"
	dest.puts "#{input_General[:input_class_key]}#{input_General[:inputClassSeparate]} #{input_General[:inputClass_2]}"
	dest.puts "<#{input_General[:inputURL_2]}>"
	dest.puts "#{input_General[:inputEnd]}"

        # MC: same as above

	dest.puts ""
	#dest.puts "%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	dest.puts ""



	#bk_General = {:bk_ontology_key => "ontology",
	#				:bk_name => "bk",
	#				:bk_URL => bk_repository,
	#				:bk_end => "end", 
	#				:bk_name_end => "="}
	# ----- write background knowledge to input.dol

	#bk_repository = "https://ontohub.org/animal_monster/animalKnowledge.owl"
             # MC: there is already a variable for this in the create function... Yup... I forgot...thanks.!
	bk_General = make_BK_Form(bk_repository)
	dest.puts "#{bk_General[:bk_ontology_key]} #{bk_General[:bk_name]} #{bk_General[:bk_name_end]}"
             # MC: I corrected the order, so you get "ontology O_name =" and not "ontology = O_name" ... Ohh... I made a mistake here...
	dest.puts "<#{bk_General[:bk_URL]}>"
	dest.puts "#{bk_General[:bk_end]}"

	dest.puts ""
	#dest.puts "%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	dest.puts ""


	# ----- write base to input.dol	
	# 		baseGeneralForm = { :base_ontology_key => "ontology",
	#						:base_name => "base",
	#						:base_class_key => "Class", 
	#						:base_class => "Monster", 
	#						:base_end => "end", 
	#						:base_name_end => "=",
	#						:base_class_separate => ":"}

	#sharedObjectProperty, sharedClass = create_base(input_General, base_General, morphism_General)
            # MC: you have called this already in create.rb
	#sharedStructureForm = make_sharedStructureForm_Form()
	dest.puts "#{base_General[:base_ontology_key]} #{base_General[:base_name]} #{base_General[:base_name_end]}"
	dest.puts "#{base_General[:base_class_key]}#{base_General[:base_class_separate]} #{base_General[:base_class]}"

	#		sharedStructureForm_features = {:structure_property => "ObjectProperty",
	#							:structure_separate => ":",
	#							:structure_class => "Class",
	#							:structure_subclass => "SubClassOf"		
	#							}
	sharedClass.each do |s_class|
		dest.puts "#{sharedStructureForm[:structure_class]}#{sharedStructureForm[:structure_separate]} #{s_class}"	
	end
	
	dest.puts ""

	sharedObjectProperty.each do |property|
		dest.puts "#{sharedStructureForm[:structure_property]}#{sharedStructureForm[:structure_separate]} #{property}"
	end

	dest.puts "#{base_General[:base_end]}"
	
	dest.puts ""	
	#dest.puts "%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	dest.puts ""

	
	# ----- write base morphisms to input.dol
	# 		morphismGeneralForm = { :morphismName_1 => "animalMorphism1", 
	#							:name_map_1 => "#{base_General[:base_name]} to #{input_General[:inputName_1]}", 
	#							:class_map_1 => "#{base_General[:base_class]} |-> #{input_General[:inputClass_1]}", 
	#							:morphismName_2 => "animalMorphism2", 
	#							:name_map_2 => "#{base_General[:base_name]} to #{input_General[:inptuName_2]}", 
	#							:class_map_2 => "#{base_General[:base_class]} |-> #{input_General[:inputClass_2]}",
	#							:morphism => "interpretation",
	#							:morphismNameEnd => ":",
	#							:morphismMapEnd => "=" }

	# interpretation hoti12Horse: hoti1 to horse  =
	#		Organism |-> Horse 

	# interpretation hoti12Tiger: hoti1 to tiger  =
	#		Organism |-> Tiger

	dest.puts "#{morphism_General[:morphism]} #{morphism_General[:morphismName_1]}#{morphism_General[:morphismNameEnd]} #{morphism_General[:name_map_1]} #{morphism_General[:morphismMapEnd]}"	
	dest.puts "#{morphism_General[:class_map_1]}"

	dest.puts ""
	dest.puts ""

	dest.puts "#{morphism_General[:morphism]} #{morphism_General[:morphismName_2]}#{morphism_General[:morphismNameEnd]} #{morphism_General[:name_map_2]} #{morphism_General[:morphismMapEnd]}"	
	dest.puts "#{morphism_General[:class_map_2]}"
	
	dest.puts ""
	#dest.puts "%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	dest.puts ""


	# ----- write command to create blend directed to hets to input.dol
	#blendoid_General = {:blendoid_ontology => "ontology",
	#				:blendoid_name => "monsterBlend",
	#				:blendoid_command => "combine",
	#				:blendoid_interpretation_1 => "#{morphism_General[:morphismName_1]}",
	#				:blendoid_interpretation_2 => "#{morphism_General[:morphismName_2]}",
	#				:blendoid_separate => ","
	#				:blendoid_name_end => "="
	#				}


	# ontology monsterblend1  = 
    #	combine hoti12Horse, hoti12Tiger 
	#	with  Organism |-> Monster

	blendoid_General = make_Blendoid_Form(morphism_General)	
	
	dest.puts "#{blendoid_General[:blendoid_ontology]} #{blendoid_General[:blendoid_name]} #{blendoid_General[:blendoid_name_end]}"
	dest.puts "#{blendoid_General[:blendoid_command]} #{blendoid_General[:blendoid_interpretation_1]}#{blendoid_General[:blendoid_separate]} #{blendoid_General[:blendoid_interpretation_2]}"
	
	dest.puts ""
	#dest.puts "%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	dest.puts ""


	# ----- write query to input.dol	
	# ontology evalmb1 = monsterblend1 and backgroundKnowledge
	# 	query_structure = {:query_ontology => "ontology",
	#					:query_name => "monster_evaluate",
	#					:query_blend => blend,
	#					:query_check => bKnowledge,
	#					:query_separate => "and",
	#					:query_name_end => "="		
	#					}

	query_General = make_Evaluation_Query(blendoid_General[:blendoid_name], bk_General[:bk_name])

	dest.puts "#{query_General[:query_ontology]} #{query_General[:query_name]} #{query_General[:query_name_end]} #{query_General[:query_blend]} #{query_General[:query_separate]} #{query_General[:query_check]}"

	dest.puts ""
	#dest.puts "%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	dest.puts ""


	dest.close()

	destination = "input.dol"

	return destination, query_General[:query_name]
	 

end

