require 'open3'
require 'io/wait'

inputfilename = "blendTigerHorse.dol"
blendnodename = "evalmb1"

def send_cmd(cmd, stdin, stdout, wait=false, waitfor1=nil, waitfor2=nil)
#  puts "\e[01;36m#{cmd}\e[00m"
  stdin.puts cmd
  if wait then
    out = ""
    loop do
      sleep 0.03
      if stdout.ready?
        out1 = stdout.read_nonblock(1000000)
        puts  ("out1:"+out1)
        out << out1
        if waitfor1.nil? or out.include?(waitfor1) or waitfor2.nil? or 
               out.include?(waitfor2)
          return out
        end
      end
    end  
  else
    return ""
  end
end



# evaluate the blends for consistency
def evaluate_blend(o, stdin, stdout, inputfilename)
  send_cmd("use " + inputfilename, stdin, stdout)
  send_cmd("dg basic " + o, stdin, stdout)
  send_cmd("cons-checker darwin",stdin,stdout)
  send_cmd("set time-limit 10",stdin,stdout)
  puts("checking consistency")
  out = send_cmd("check-consistency",stdin,
                 stdout,true, "consistent", "Timeout")
  puts("finished")
  puts("Out:"+out)
  if out.include?("is consistent") then 
    return :consistent
  end
  i = weaken(inputfilename)  #here I want to call a program
  if (i == 0)
    return :inconsistent
   else 
    puts("recursive call "+i.to_s)
    evaluate_blend(o, stdin, stdout, inputfilename)
  end
end

def weaken(fname)
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
    weaken(fname)
   else
    return occurNo
  end
end

Open3.popen3('hets -I') do | stdin, stdout, stderr |
 case evaluate_blend(blendnodename, stdin, stdout, inputfilename)
   when :consistent 
     puts "consistent"
     send_cmd("hets -o th "+inputfilename, stdin, stdout)
     exit
   when :inconsistent
     puts "removed all sentences"
     exit
 end
end
