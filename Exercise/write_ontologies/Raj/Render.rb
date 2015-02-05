load "pp.rb"
require 'json'

####################################### Render Method ############################################

# Method to generate the desired input file for Monster Rendering System from the Input Ontology

def Render(ontology)

# Extracting object Property "meets" from Ontology to find the meet-pairs
  ontology.o_signature.objProps.each do  |n|
    if(n.name=="meets")
      $op2=AtomicObjectProperty.new(n)
    end
  end

# Initializing meet-pairs in the given ontology
  $meetpairs = Array.new

# Initializing pairs other than meet-pairs in the given ontology
  $otherpairs= Array.new

# Initialized for finding the sentence patterns that match meet-pairs
  $patterns  = Array.new

# Initialized to find the patterns used to derive Definitions
  $Definitionpatterns  = Array.new

  $i=0

# Finding meet-pairs from all the sentences in Ontology
while $i<ontology.o_sentences.length do
  if ontology.o_sentences[$i].is_a?(FactAssertion)&&ontology.o_sentences[$i].components[1].name.name==$op2.name.name
    $meetpairs.push(ontology.o_sentences[$i])
  else
    $otherpairs.push(ontology.o_sentences[$i])
  end
  $i +=1
end

# Finding pairs other than meet-pairs
for i in $meetpairs.length.times do
  for j in 0..2 do
    if j!=1 then
      for k in $otherpairs.length.times do
        if $meetpairs[i].components[j]==$otherpairs[k].components[0]||$meetpairs[i].components[j]==$otherpairs[k].components[2]
          $patterns.push($otherpairs[k])
        end
      end
    end
  end
end

# Finding Definition Patterns
for i in $patterns.length.times do
  if $patterns[i].is_a?(FactAssertion)
    for k in $otherpairs.length.times do
      if ($patterns[i].components[0]==$otherpairs[k].components[0])&&($otherpairs[k].is_a?(TypeAssertion))
        $Definitionpatterns.push($otherpairs[k])
      end
    end
  end
end

# Method to find the Relation Patterns
  def findRelations(point)

    for i in $patterns.length.times do
      if (point==$patterns[i].components[0].name)
        for j in $patterns.length.times do
          if($patterns[i].components[2].name==$patterns[j].components[0].name)
            return $patterns[j].components[1].name.name
          end
        end
      end
    end
  end

# Creating Markup File for Monster Rendering System
File.open("_markup.json","w") do |f|

  # Loading Definitions into Markup File
  f.write("{\n")
  f.write("  \"Definitions\": [\n")
  for i in $Definitionpatterns.length.times do
    f.puts "   {"
    f.puts "     \"Identifier\": "+ "\""+ "#{$Definitionpatterns[i].components[0].name}"+ "\""+","
    f.puts "     \"Type\": "+ "\""+ "#{$Definitionpatterns[i].components[1].name.name}"+ "\""
    if i==$Definitionpatterns.length-1
      f.print "   }"
    else
      f.puts "   },"
    end
  end
  f.write("\n  ],")

  # Loading Relations into Markup File
  f.write("\n  \"Relations\": [\n")
  for i in ($Definitionpatterns.length-1).times do
    f.puts "   {"
    f.puts "     \"Individual1\": "+ "\""+ "#{$Definitionpatterns[i].components[0].name}"+ "\""+","
    $point1=findRelations("#{$Definitionpatterns[i].components[0].name}") # Finding Relation using FindRelations Method

    f.puts "     \"Point1\": "+ "\""+ "#{$point1}"+ "\""+","

    f.puts "     \"Individual2\": "+ "\""+ "#{$Definitionpatterns[i+1].components[0].name}"+ "\""+","
    $point2=findRelations("#{$Definitionpatterns[i+1].components[0].name}") #Finding Relation using FindRelations Method

    f.puts "     \"Point2\": "+ "\""+ "#{$point2}"+ "\""

    if i==$Definitionpatterns.length-2
      f.print "   }"
    else
      f.puts "   },"
    end
  end
  f.write("\n  ]\n")
  f.write("}")
end
end

####################################### End Of Render Method ############################################

# Sample code to which the markup file will be generated

=begin
ObjectProperty: has_fiat_boundary
ObjectProperty: meets

Class: ProximalBoundary
Class: HorseHead
Class: HorseTrunk
Class: TrunkNeckBoundary

Individual: h
Types: HorseHead
Facts: has_fiat_boundary h-nb

Individual: h-nb
Types: ProximalBoundary
Facts: meets t-nb

Individual: t
Types: HorseTrunk
has_fiat_boundary t-nb

Individual: t-nb
Types: TrunkNeckBoundary
=end

# Loading Sample Code to Standard Data Structure to pass into Render Method

hfb = Symbols.new(ROLE, "has_fiat_boundary")
op1=AtomicObjectProperty.new(hfb)

m = Symbols.new(ROLE, "meets")
op2=AtomicObjectProperty.new(m)

pb = Symbols.new(CLASS, "ProximalBoundary")
pbc = AtomicConcept.new(pb)

tnb = Symbols.new(CLASS, "TrunkNeckBoundary")
tnbc = AtomicConcept.new(tnb)

hh = Symbols.new(CLASS, "HorseHead")
hhc = AtomicConcept.new(hh)

ht = Symbols.new(CLASS, "HorseTrunk")
htc = AtomicConcept.new(ht)

hnb=Symbols.new(INDIVIDUAL,"h-nb")

tnbi=Symbols.new(INDIVIDUAL,"t-nb")

h=Symbols.new(INDIVIDUAL,"h")

t=Symbols.new(INDIVIDUAL,"t")

s1=TypeAssertion.new(h,hhc)
s2=FactAssertion.new(h,op1,hnb)

s3=TypeAssertion.new(hnb,pbc)
s4=FactAssertion.new(hnb,op2,tnbi)

s5=TypeAssertion.new(t,htc)
s6=FactAssertion.new(t,op1,tnbi)

s7=TypeAssertion.new(tnbi,tnbc)


cSet = Set[pb,tnb,hh,ht]
oSet = Set[m,hfb]
dSet = Set[]
iSet = Set[h,hnb,t,tnbi]

sigma = Signature.new(cSet,oSet,dSet,iSet)
ontology = Ontology.new(sigma, [s1, s2, s3,s4,s5,s6,s7])

# A Call to  Render method with the Sample Ontology assumed to generate the markup file 
Render(ontology)
