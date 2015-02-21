require 'open-uri'
require 'uri'
# ------ call hets to test the consistency of the blendoid

def consistent_blend?(blendResult, backgroundKnowledge)



File.open("union.dol","w") do |f|
  f.puts "logic OWL"
  f.puts "ontology O = "
  f.puts File.readlines("#{blendResult}")
  f.puts " and "
  f.puts File.readlines("#{backgroundKnowledge}")
  f.close
end

open3.popen3('hets -I') do | stdin, stdout, stderr |
  case evaluate_blend("evalmb1", stdin, stdout)
    when :consistent
      puts "consistent"
      exit
    when :inconsistent
      puts "removed all sentences"
      exit
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

end
consistent_blend?("blending.dol","animals.dol")
