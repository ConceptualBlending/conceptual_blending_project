def pp(req_string)
   file = File.open("examples.rb", 'r')
   while !file.eof?
      line = file.readline 
      if line.match(req_string)
         s1=line.split("(")
         s2 = s1[1].sub!(',',':')
         s3 = s2.gsub('"', ' ')
         s4 = s3.sub!(')', ' ')
         puts s4 
      end
    end
end

def test()
   pp("CLASS")
   pp("ROLE")
end

test()
