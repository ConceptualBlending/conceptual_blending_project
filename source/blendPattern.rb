



def select_blend_pattern


blendPattern = "blendPattern.dol"
# open the dol file for blending pattern, wipe it clean
#File.open('blendPattern.dol', 'w') {|file| file.truncate(0) }

print "selecting the blending pattern...\n"

# clear the file before writing


#connect to the blend pattern repository

#blend_pattern = blendPattern

if File.exists?('blendPattern.dol')
	print "blending pattern selected...\n"
	return
else
	print "file does not exist...\n"
	abort 

end


end

#select_blend_pattern()
