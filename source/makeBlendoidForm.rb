
#ontology monsterblend1  = 
 #   combine hoti12Horse, hoti12Tiger 
#	with  Organism |-> Monster


# This method gives the form of the command to create a blendoid. This form is sent to hets to general blendoid.
# Here I have assumed that the following form is the standard form. If there are some other forms, changes need to be made

def make_Blendoid_Form(morphism_General)

blendoid_General = {:blendoid_ontology => "ontology",
					:blendoid_name => "monsterBlend",
					:blendoid_command => "combine",
					:blendoid_interpretation_1 => "#{morphism_General[:morphismName_1]}",
					:blendoid_interpretation_2 => "#{morphism_General[:morphismName_2]}",
					:blendoid_separate => ",",
					:blendoid_name_end => "="
					}

return blendoid_General

end

# MC: constants
