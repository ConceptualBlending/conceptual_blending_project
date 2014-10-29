#!/usr/bin/ruby

require 'open3'
require 'io/wait'


require_relative "makeBlendPattern"
require_relative "selectInput"
require_relative "makeSharedStructureForm"
require_relative "makeBase"
require_relative "makeInputFile"
require_relative "makeEvaluation"
#require_relative "makeBaseForm"
#require_relative "makeMorphismForm"
#require_relative "makeInputForm"
#require_relative "makeInput"
#require_relative "evaluation"
#require_relative "makeBlendoid"


def create


	#inputfilename = "input.dol"	
	blendnodename = "evalmb1"

	#bkfilename = "backgroundKnowledge.dol"
	#requirement = "requirement.dol"
	

	## initialize 
	#final_blendoid = "empty blendoid...!!!\n"


	# ----- select the blending pattern; arguments? initially only 'v'-shaped pattern will be used for blending..
	# ----- possible arguments: url of the remote location or path of the local directory?
	# ----- blend pattern = input space 1, input space 2, base, base morphism 1, base morphism 2
	# ----- ruby: struct, hash or class? for blend_pattern
	# ----- blendPattern = Struct.new(:input_space, :base, :morphism)	
	# ----- the remote location to store the repositories is not yet finalized, hence sending the blank value.
	# ----- handling urls is not yet done, it will be done soon.
	
	repository = "v_pattern"
	# repository = "https://ontohub.org/animal_monster/blend_pattern"
	
	input_General, base_General, morphism_General = select_blend_pattern(repository) 

	print "---------------------------------------------------\n"	
	print "Input space general form: \n"
	input_General.each do |key, value|
		puts "#{key} : #{value}"
	end	
	print "---------------------------------------------------\n"

	print "---------------------------------------------------\n"	
	print "base general form: \n"
	base_General.each do |key, value|
		puts "#{key} : #{value}"
	end
	print "---------------------------------------------------\n"


	print "---------------------------------------------------\n"	
	print "base morphism general form: \n"
	morphism_General.each do |key, value|
		puts "#{key} : #{value}"
	end
	print "---------------------------------------------------\n"	

	# ----- extract the input spaces from the repository. Extract is guided by the blending pattern, requirement and background knowledge
	# ----- list of URLs of selected input spaces. List will allow to handle more than two URLs in case of more complex blending patterm where more than two input spaces are selected
	# ----- send the url of background knowledge located on ontohub
	bkfilename = "https://ontohub.org/monster-blend/background/animalKnowledge.owl"
	# ----- send the url of requirement located on ontohub
	# ----- requirement file is not there, fabian can you please make the requirement file. Since the requirement file is not present at the moment, no value is sent for requirement
	# requirement = "https://ontohub.org/monster-blend/background/animalKnowledge.owl"
	requirement = ""

	input_General_New = select_input_space(input_General, bkfilename, requirement)

	print "---------------------------------------------------\n"
	print "Input space general form with selected input spaces:\n"
	input_General_New.each do |key, value|	
		puts "#{key} : #{value}"
	end
	print "---------------------------------------------------\n"

	sharedStructureForm = make_shared_structure_form()

	print "---------------------------------------------------\n"	
	print "The shared structure form is: \n"
	sharedStructureForm.each do |key, value|
		puts "#{key} : #{value}"
	end
	print "---------------------------------------------------\n"

	
	# ----- once the input spaces are extracted, create a base and base morphisms.
	# ----- The structure of the base and base morphism depends on the blending pattern
	
	sharedObjectProperty, sharedClass = create_base(input_General, base_General, morphism_General)
	
	print "---------------------------------------------------\n"
	print "The shared object properties are: \n"
	sharedObjectProperty.each do |property|
		puts property
	end
	print "---------------------------------------------------\n"

	print "---------------------------------------------------\n"	
	print "The shared classes are: \n"
	sharedClass.each do |sClass|
		puts sClass
	end
	print "---------------------------------------------------\n"

	
	# ----- make the input .dol file to be sent to hets for creating the blends

	#blend_input = make_input_file(input_General, base_General, morphism_General)
	blend_input = make_input_file(input_General, base_General, morphism_General)
	#blend_input = "input.dol"	
	puts blend_input
	#rint "reading the input...\n"
	#inputForBlend = "input.dol"

	#blend_input_1 = "input_file.dol"	

	# ----- create blendoid
	
	
 	

	# ----- check consistency and requirement satisfaction
	# ----- needs to deal with nodefilename
	Open3.popen3('hets -I') do | stdin, stdout, stderr |
	case evaluate_blend(blendnodename, stdin, stdout, blend_input)
  		when :consistent 
  			puts "consistent"
 			send_cmd("hets -o th "+blend_input, stdin, stdout)
			exit
		when :inconsistent
			puts "removed all sentences"
			exit
		end
	end

	# i have not added method for conflict sets. It will be added soon...

	return 

end

create()
	







