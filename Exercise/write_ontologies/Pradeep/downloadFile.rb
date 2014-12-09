def generateListOfFiles(path)
   system("git clone https://github.com/ConceptualBlending/conceptual_blending_project.git")
   if Dir[path] == nil
      puts "Entered wrong path"
   end
   Dir.chdir(path)
   puts "\nList of Owl Files :" ,Dir.glob("*.owl")
   puts "\nList of dol Files :" ,Dir.glob("*.dol")
end


generateListOfFiles("/home/pradeep/FunProg/RubyFun/OVGU_Prjct/conceptual_blending_project/Exercise/write_ontologies")
                                                                                                                           
