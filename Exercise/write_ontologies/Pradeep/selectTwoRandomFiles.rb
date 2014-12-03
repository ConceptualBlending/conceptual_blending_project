def selectRandomFile(filePath)
      file_dir = Dir.entries(filePath)
      file_dir.delete_if {|file_name| file_name == ".." or file_name == "." or file_name == " "}
      2.times do
         file_size = file_dir.size
         puts file_dir[rand(1..file_size)]
      end
end


selectRandomFile("/home/pradeep/conceptual_blending_project/Exercise/write_ontologies")
