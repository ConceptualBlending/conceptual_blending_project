
#require 'open_uri'

require_relative "makeBaseForm"
require_relative "makeMorphismForm"
require_relative "makeInputForm"

# input required? blend_patterns stored at remote loacation (ontohub)? 
def select_blend_pattern(blendPattern)
	
	if blendPattern == "v_pattern"
		# since the blending pattern format is not yet finalized, simplest format is assumed. That is, how many input spaces, base and base morphisms
		# the array of input space, base and base morphism is created with blank values, the number of blank values depend on the blending pattern 
		input_space = 2
		base_form = 1
		morphism_form = 2
		inputGeneral = make_Input_Form(input_space)
		baseGeneral = make_Base_Form(base_form)
		morphismGeneral = make_Morphism_Form(morphism_form, inputGeneral, baseGeneral)
		return [inputGeneral, baseGeneral, morphismGeneral]
	else
		return "no pattern is chosen"
	end
	# assign the urls to input_space array
	#blend_pattern.input_space = [repository+"/horse.owl", repository+"/tiger.owl"]
	#blend_pattern.base = "base.dol"
	#blend_pattern.morphism = 
	#blendPattern = "blendPattern.dol"
	# open the dol file for blending pattern, wipe it clean
	#File.open('blendPattern.dol', 'w') {|file| file.truncate(0) }
	#print "selecting the blending pattern...\n"
	# clear the file before writing
	# decide the pattern according to requirements and selection criteria?
	# connect to the blend pattern repository
	# extract the decided pattern
	# or create the decided pattern
	#if File.exists?('blendPattern.dol')
		#print "blending pattern selected...\n"
		#return
	#else
		#print "file does not exist...\n"
		#abort 
	#end
end


# patterns will be stored in separate .dol files or .owl files or in some other format?? or the patterns will be stored as a single entity
# pattern need not be stored, can be created after the deciding what kind of patten is required?
# where the patterns will be stored?  on ontohub or github?
# in case of patterns stored as files, 
# pattern extraction: decision driven by selection criteria, requirement?
# the decision which pattern to be extracted will be done before extraction, the pattern data stored in files need not be parsed?
# how the patterns will be formalized? do they need to be formalized as .dol files?
# the formalization given in blendPattern.dol is the standard one? can hets handle more complex patterns? if yes, examples?



# attributes for data structure, based on the pattern description given in monster blend
# 1. ontology: title for ontology - automatically generated or given by the programmer?
# 2. 

