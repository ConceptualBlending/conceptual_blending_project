

require 'uri'


def select_input_space(input_General, bkfilename, requirement)

	# ----- next task: HETS can be used here to parse all the input files to make the contents available to the selection process. 
	# ----- at the moment, urls are assigned directly. 
	
		input_General[:inputURL_1] = "https://ontohub.org/animal_monster/horse.owl"
		input_General[:inputURL_2] = "https://ontohub.org/animal_monster/tiger.owl"

             # MC: why do you have arguments that you don't use? It seems to me that here you
             # MC: would need to store bkfilename as well
		
	return input_General	 

end


