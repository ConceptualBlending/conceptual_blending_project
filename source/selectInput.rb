



def select_input_space(blend_pattern, bkfilename, requirement)

#File.open(input_space, 'w') {|file| file.truncate(0) }

print "selecting the input spaces...\n"


# clear the file before writing

# select input spaces based on background knowledge, requirement and blending pattern

if File.exists?(blend_pattern) and File.exists?(bkfilename) and File.exists?(requirement)



# select the input space

# write into 'inputspace.dol'

	print "input spaces selected...\n"
	return

else 
	print "File is missing...\n"
	abort
end

end

#select_input_space(blend_pattern, bkfilename, requirement)
