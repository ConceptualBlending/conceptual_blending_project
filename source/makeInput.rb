


def make_input(input_space, bkfilename, base, blend_pattern)

# clear the file before writing

if File.exists?('input.dol') and File.exists?(blend_pattern) and File.exists?(bkfilename) and File.exists?(base) and File.exists?(input_space)

# write the input space into inputspace.dol

dest = File.open('input.dol', 'w') #{|file| file.truncate(0) }

print "combining all inputs...\n"

ispace = File.open(input_space)
data_to_copy = ispace.read()
dest.write(data_to_copy)
dest.close()


open('input.dol', 'a') { |f|
	File.readlines(bkfilename).each do |line1| 
		if line1.include?("logic OWL")
			next
		 else
	        	f.puts line1	
 		end
	end
	File.readlines(base).each do |line2|
		if line2.include?("logic OWL")
			next
		else
			f.puts line2
		end	
	end
	File.readlines(blend_pattern).each do |line3|
		if line3.include?("logic OWL")
			next
		else
			f.puts line3
		end
	end
f.close	
}

	print "inputs combined, can be used for blending...\n"
	return

else 
	print "File is missing...\n"
	abort
end




end

