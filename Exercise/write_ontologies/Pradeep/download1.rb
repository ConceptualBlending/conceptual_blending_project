def generateListOfFiles(path)
   system("git clone" +path)
   if Dir[path] == nil
      puts "Entered wrong path"
   end
   Dir.chdir("conceptual_blending_project/Exercise/write_ontologies")

   puts "\nList of Owl Files :" ,Dir.glob("*.owl")
   puts "\nList of dol Files :" ,Dir.glob("*.dol")
end


generateListOfFiles(" https://github.com/ConceptualBlending/conceptual_blending_project.git")
