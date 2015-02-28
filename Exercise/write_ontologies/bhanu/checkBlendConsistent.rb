
def consistent_blend?(blendResult, backgroundKnowledge)

 # TASK: 
  # generate a DOL file with the union of the blend and the background knowledge
    # pattern
    # logic OWL 
    # ontology O = 
     # <blendResult.onto_url> and <backgroundKnowledge.onto_url>
  # use HETS to check for consistency
    # here is where the code from cons.rb should go   
  # return the result of consistency check

sig1 = blendResult.o_signature

c_n=Array.new()
o_p=Array.new()
d_p=Array.new()
x=Array.new()
i=0
j=0

sig1.concepts.each do |x|
c_n.push(x.name)
end
#puts c_n
sig1.objProps.each do |x|
o_p.push(x.name)
end
sig1.dataProps.each do |x|
d_p.push(x.name)
end
sig1.individuals.each do |x|
x.push(x.name)
end
	
sens1 = blendResult.o_sentences

File.open("union.dol","w") do |f|
  f.puts "logic OWL"
  f.puts "ontology O ="
begin
	 f.puts "Class : " + c_n[i].to_s
   	i+=1
end while (i<c_n.length)
begin
	 f.puts "ObjectProject : " + o_p[j].to_s
   	j+=1
end while (j<o_p.length)

 
 
f.puts "\nand "

fileObj = File.new(backgroundKnowledge, "r")
	while (line = fileObj.gets)
		f.puts line
	end
fileObj.close
f.close

end
end

=begin
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
=end