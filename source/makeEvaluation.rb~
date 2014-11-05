require 'open3'
require 'io/wait'

#inputfilename = "input.dol"
#blendnodename = "evalmb1"

require_relative 'weakenInput'

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
def make_Evaluation(o, stdin, stdout, inputfilename)
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
  	i = weaken_Input(inputfilename)  #here I want to call a program
  	if (i == 0)
    	return :inconsistent
   	else 
    puts("recursive call "+i.to_s)
    make_Evaluation(o, stdin, stdout, inputfilename)
  	end
end




