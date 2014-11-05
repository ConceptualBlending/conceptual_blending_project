#!/usr/bin/ruby

require 'open3'
require 'io/wait'


require_relative "makeBlendPattern"
require_relative "selectInputSpace"
require_relative "makeSharedStructureForm"
require_relative "makeBase"
require_relative "makeInputFile"
require_relative "makeEvaluation"

# MC: don't leave in your file commented-out code, it makes the file hard to read    

def my_print(x, s) # MC: don't duplicate code, use functions, like this one
 	print "---------------------------------------------------\n"	
	print s
	x.each do |key, value|
		puts "#{key} : #{value}"
	end	
	print "---------------------------------------------------\n"
end


# to pass the values from create.rb to whereever they are required.
# def send_values(a); end

def create

	# ----- select the blending pattern; arguments? initially only 'v'-shaped pattern will be used for blending..
	# ----- possible arguments: url of the remote location or path of the local directory?
	# ----- blend pattern = input space 1, input space 2, base, base morphism 1, base morphism 2
	# ----- ruby: struct, hash or class? for blend_pattern
	# ----- blendPattern = Struct.new(:input_space, :base, :morphism)	
	# ----- the remote location to store the repositories is not yet finalized, hence sending the blank value.
	# ----- handling urls is not yet done, it will be done soon.
	
	repository = "v_pattern"
	
	input_General, base_General, morphism_General = make_Blend_Pattern(repository) 
           

        my_print(input_General, "Input space general form: \n")
        my_print(base_General, "base general form: \n")
        my_print(morphism_General, "base morphsim general form: \n")


    # ----- extract the input spaces from the repository. Extract is guided by the blending pattern, requirement and background knowledge
	# ----- list of URLs of selected input spaces. List will allow to handle more than two URLs in case of more complex blending patterm where more than two input spaces are selected
	# ----- send the url of background knowledge located on ontohub

	bkfilename = "https://ontohub.org/animal_monster/animalKnowledge.owl"
	
    # ----- send the url of requirement located on ontohub
	# ----- requirement file is not there, fabian can you please make the requirement file. Since the requirement file is not present at the moment, no value is sent for requirement
	
	requirement = ""

	input_General_New = select_Input_Space(input_General, bkfilename, requirement)

        my_print(input_General_New, "Input space general form with selected input spaces:\n")

	sharedStructureForm = make_Shared_Structure_Form()

        my_print(sharedStructureForm, "The shared structure form is: \n")

    # ----- once the input spaces are extracted, create a base and base morphisms.
	# ----- The structure of the base and base morphism depends on the blending pattern
	
	sharedObjectProperty, sharedClass = make_Base(input_General, base_General, morphism_General)
             # MC: again, create_base vs makeBase.rb
	
	my_print(sharedObjectProperty, "The shared object properties are: \n")
	
	
	my_print(sharedClass, "The shared object properties are: \n")
	

            # MC: above, use some auxiliary function for displaying...
	
	# ----- make the input .dol file to be sent to hets for creating the blends

	
	blend_input, query_name = make_Input_File(input_General, base_General, morphism_General, bkfilename, sharedStructureForm, sharedObjectProperty, sharedClass)
	
	puts blend_input
	
	# ----- create blendoid	
	# ----- check consistency and requirement satisfaction
	# ----- needs to deal with nodefilename
	Open3.popen3('hets -I') do | stdin, stdout, stderr |
	case make_Evaluation(query_name, stdin, stdout, blend_input) # MC: I have changed the first argument, it was from old code
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
	







