# Get the parts of speech
def multireturn
  return ["Hello", "World"]
end

a, b = multireturn    #this is where the magic happens...

puts "return 1: #{a}"
puts "return 2: #{b}"
