# This method weakens the input. It needs to be improved considerably. 


def weaken_Input(fname)
  puts("Weaken")
  lines = File.read(fname).split("\n")
  occurNo = File.read(fname).scan("SubClassOf:").count

  File.open(fname, "w") do |file|
    lines.each do |line|
     if (line.scan("SubClassOf:").length == 1) 
        puts ("step ")
        rNumber = 1 + rand(occurNo)
        puts("rn:"+rNumber.to_s)  
        if (rNumber != occurNo)
            file.write(line+"\n")
          else 
             puts("deleted:"+line)
          end
      else
        file.write(line+"\n")
     end
    end
  end

  occurNo2 = File.read(fname).scan("SubClassOf:").count

  if (occurNo ==  occurNo2) 
    weaken_Input(fname)
   else
    return occurNo
  end
end
