def replace(string)
file = File.open("sample.owl",'r')
while !file.eof?
   line = file.readline
   if line.match(string)
		puts("the instance is #{line}\n")
		
		new = line.gsub!string,'SubclassOf'
		puts("the new instance is #{new}\n")
   end

end
end
def find()
replace("EquivalentTo")
end
find()
