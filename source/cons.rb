#!/usr/bin/ruby

# experimental script for finding axiom sets suitable for proofs with SPASS
require 'open3'
require 'io/wait'

def send_cmd(cmd,stdin,stdout,wait=false,waitfor=nil)
#  puts "\e[01;36m#{cmd}\e[00m"
  stdin.puts cmd
  if wait then
    out = ""
    loop do
      sleep 0.03
      len = stdout.ready?
      if len
        out1 = stdout.sysread(len)
#        print out1
        out << out1
        if waitfor.nil? or out.include?(waitfor)
          return out
        end
      end
    end  
  else
    return ""
  end
end

def evaluate_blend(o,stdin,stdout)
  send_cmd("use animal.dol", stdin, stdout)
  send_cmd("dg basic " + o, stdin, stdout)
  send_cmd("cons-checker darwin",stdin,stdout)
  send_cmd("set time-limit 100",stdin,stdout)
  puts("checking consistency")
  out = send_cmd("check-consistency",stdin,
                 stdout,true, "consistent")
  puts("finished")
  puts("Out:"+out)
  if out.include?("is Consistent") then 
    return :consistent
  end
  i = weaken("animal.dol")  #here I want to call a program
  if (i == 0)
    return :inconsistent
   else 
    puts("recursive call "+i.to_s)
    evaluate_blend(o, stdin, stdout) 
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
  
  puts("oN:"+occurNo.to_s)
  return occurNo
end

Open3.popen3('hets -I') do | stdin, stdout, stderr |
 case evaluate_blend("evalmb1", stdin, stdout)
   when :consistent 
     puts "consistent"
     exit
   when :inconsistent
     puts "removed all sentences"
     exit
 end
end
