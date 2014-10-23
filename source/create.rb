#!/usr/bin/ruby


###### the following files are required
## %%%%%%% blendPattern.rb returns the 
# experimental script for finding axiom sets suitable for proofs with SPASS
# require 'open3'
#require 'io/wait'
#require 'evaluation'

require 'open3'
require 'io/wait'


require_relative "blendPattern"
require_relative "selectInput"
require_relative "makeBase"
require_relative "makeInput"
require_relative "evaluation"
require_relative "makeBlendoid"
#require 'inputSpace'
#require 'mainInput'
#require 'makeBase'
#require 'makeBlendoid'

def create


inputfilename = "input.dol"
blendnodename = "evalmb1"


#inputfilename = "blendTigerHorse.dol"
#blendnodename = "evalmb1"
bkfilename = "backgroundKnowledge.dol"
requirement = "requirement.dol"
#inputspace = "inputspace.dol"

## initialize 
final_blendoid = "empty blendoid...!!!\n"


# select the blending pattern
select_blend_pattern() 
print "reading the blending pattern...\n"
blend_pattern = "blendPattern.dol"
#blendPattern = File.open(blend_pattern, "r") 


# extract the input spaces from the repository. Extract is guided by the blending pattern, requirement and background knowledge
select_input_space(blend_pattern, bkfilename, requirement)
print "reading the input spaces...\n"
input_space = "inputspace.dol"


# once the input spaces are extracted, create a base and base morphism followed by interpretation the base
create_base(input_space)
print "reading the base...\n"
base = "baseMorphism.dol"


# combine all the files into one file
make_input(input_space, bkfilename, base, blend_pattern)
print "reading the input...\n"
inputForBlend = "input.dol"



# create blendoid
make_blendoid(inputForBlend)
print "reading blendoid...\n"
blendoid = "blendoid.dol"



# evaluate for consistency
#evaluate_blend(o, stdin, stdout, inputfilename)

 Open3.popen3('hets -I') do | stdin, stdout, stderr |
 case evaluate_blend(blendnodename, stdin, stdout, inputfilename)
   when :consistent 
     puts "consistent"
     send_cmd("hets -o th "+inputfilename, stdin, stdout)
     exit
   when :inconsistent
     puts "removed all sentences"
     exit
 end
end

# get the output from hets and print it on the screen
	




return final_blendoid

end

#Open3.popen3('hets -I') do | stdin, stdout, stderr |
result = create()
print result
	

	







