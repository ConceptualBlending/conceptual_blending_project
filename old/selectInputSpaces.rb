

def select_input_spaces(inputSpaceRepository, blendRequirement, backgroundKnowledge)

   # tasks: 
   # 1. make a local copy of the repository
   # 2. the heuristics for the selection 
      # TODO: discuss ideas 
      # select 2 of the ontologies that contain at least 1 entity in common with req or back knowledge ontologies
   # 3. parse the files containing the selected input spaces and return two instances of the Ontology class

   randomFiles = []
   system("git clone " + inputSpaceRepository +" myFolder")
   if Dir[inputSpaceRepository] == nil
      puts "Entered wrong path"
   end
   Dir.chdir("myFolder")
   file_dir = Dir.entries(Dir.pwd)
   owl_dir = file_dir.delete_if {|x| File.extname(x) != ".owl"}
   owl1 = owl_dir[rand(1..(owl_dir.size)-1)]
   owl_dir2 = owl_dir.delete_if {|x| File.basename(x) == owl1 } # To generate another random file unlike the before one 
   owl2 = owl_dir2[rand(1..(owl_dir2.size)-1)]
   randomFiles.push(owl1)
   randomFiles.push(owl2)
   return randomFiles
end

select_input_spaces("git://ontohub.org/animal_monster.git"," "," ")
	

