def selectRandomFile(filePath)
      file_dir = Dir.entries(filePath)
      owl_dir = file_dir.delete_if {|x| File.extname(x) != ".owl"}
      owl1 = owl_dir[rand(1..(owl_dir.size)-1)]
      owl_dir2 = owl_dir.delete_if {|x| File.basename(x) == owl1 } # To generate another random file unlike the before one 
      owl2 = owl_dir2[rand(1..(owl_dir2.size)-1)]
      puts owl1
      puts owl2
end

selectRandomFile("/home/pradeep/conceptual_blending_project/Exercise/write_ontologies")

