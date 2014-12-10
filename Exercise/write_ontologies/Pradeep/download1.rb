def generateListOfFiles(path)
   system("git clone" ++ path ++ "myFolder")
   if Dir[path] == nil
      puts "Entered wrong path"
   end
   Dir.chdir("myFolder")

   puts "\nList of Owl Files :" ,Dir.glob("*.owl")
   puts "\nList of dol Files :" ,Dir.glob("*.dol")
end


generateListOfFiles("git://ontohub.org/dol-examples.git")
