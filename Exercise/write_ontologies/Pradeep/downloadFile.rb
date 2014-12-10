def generateListOfFiles(path)
   system("git clone" ++ path ++ "myFolder" )
   ## change to the folder myFolder
   if Dir[path] == nil
      puts "Entered wrong path"
   end
   Dir.chdir(path)
   puts "\nList of Owl Files :" ,Dir.glob("*.owl")
   puts "\nList of dol Files :" ,Dir.glob("*.dol")
end


generateListOfFiles("https://github.com/ConceptualBlending/conceptual_blending_project.git")
                                                                                                                           
