
# ------ This method finds the shared structure in two input spaces
# Steps:
  #  anti-unification
  #  another idea: translate from OWL to CASL, call HDTP, see if the result can be translated back to OWL
  #  maybe we need a comorphism from a sublogic of CASL to OWL 
  # a better idea: encode OWL in first-order logic

load "pp.rb"

def generate_base(inputSpace_1, inputSpace_2)

# Method to make the Symbols after Intersection
  def makeSymbol(x,k)
    s=Set.new
    x.each do |n|
      s.add(Symbols.new(k,n)) # Making Symbol
    end
    return s
  end

# Intersection of Concepts

  cSet1=inputSpace_1.o_signature.concepts # Reading Concept Objects from Input Space 1
  cSet2=inputSpace_2.o_signature.concepts # Reading Concept Objects from Input Space 2

  # Loading all the concepts of Input Space 1 into Array
  $classes1=Array.new
       cSet1.each do  |n|
              n=n.name
       $classes1.push(n)
       end
  # Loading all the concepts of Input Space 2 into Array
  $classes2=Array.new
      cSet2.each do  |n|
              n=n.name
      $classes2.push(n)
      end

   x= $classes1 & $classes2 # Intersection of Classes
    cSet=Set.new
    cSet =makeSymbol(x,CLASS) # Call to make the Symbols of resultant Concepts after Intersection

# Intersection of Object Properties

  oSet1=inputSpace_1.o_signature.objProps # Reading Object Property Objects from Input Space 1
  oSet2=inputSpace_2.o_signature.objProps # Reading Object Property Objects from Input Space 2

  # Loading all the Object Properties of Input Space 1 into Array
  $objProps1=Array.new
      oSet1.each do  |n|
              n=n.name
       $objProps1.push(n)
      end

   # Loading all the Object Properties of Input Space 2 into Array
   $objProps2=Array.new
      oSet2.each do  |n|
              n=n.name
       $objProps2.push(n)
      end

   x= $objProps1 & $objProps2 # Intersection of Roles
    oSet=Set.new
    oSet =makeSymbol(x,ROLE) # Call to make the Symbols of resultant Object Properties after Intersection

# Intersection of Data Properties

  dSet1=inputSpace_1.o_signature.dataProps # Reading Data Property Objects from Input Space 1
  dSet2=inputSpace_2.o_signature.dataProps # Reading Data Property Objects from Input Space 2

  # Loading all the Data Properties of Input Space 1 into Array
  $dataProps1=Array.new
  dSet1.each do  |n|
    n=n.name
    $dataProps1.push(n)
  end

  # Loading all the Data Properties of Input Space 2 into Array
  $dataProps2=Array.new
  dSet2.each do  |n|
    n=n.name
    $dataProps2.push(n)
  end

  x= $dataProps1 & $dataProps2 # Intersection of Data Properties
  dSet=Set.new
  dSet =makeSymbol(x,DATA) # Call to make the Symbols of resultant Data Properties after Intersection

# Intersection of Individuals

  iSet1=inputSpace_1.o_signature.individuals # Reading Individual Objects from Input Space 1
  iSet2=inputSpace_2.o_signature.individuals # Reading Individual Objects from Input Space 2

  # Loading all the Individuals of Input Space 1 into Array
  $individuals1=Array.new
  iSet1.each do  |n|
    n=n.name
    $individuals1.push(n)
  end

  # Loading all the individuals of Input Space 2 into Array
  $individuals2=Array.new
  iSet2.each do  |n|
    n=n.name
    $individuals2.push(n)
  end

  x= $individuals1 & $individuals2 # Intersection of Individuals
  iSet=Set.new
  iSet =makeSymbol(x,INDIVIDUAL) # Call to make the Symbols of resultant Individuals after Intersection


  # Base Ontology
  sigma = Signature.new(cSet,oSet,dSet,iSet)
  o = Ontology.new(sigma,[])

  # Morphisms

  # loading all the Class symbols of generate base ontology into Array
  $osymbols=Array.new
  cSet.each do  |n|
    n=n.name
    $osymbols.push(n)
  end
  h=[$osymbols,$osymbols].transpose.to_h # Creation of a symbol map of Symbols from O to itself

  # Creating two Instances of Morphisms
  m1=Morphism.new(o,inputSpace_1,h)
  m2=Morphism.new(o,inputSpace_2,h)

  return o,m1,m2 # Returns generated base Ontology and the two Instances of Morphisms

end

# Example Input Spaces to generate base

# InputSpace1
# Class: Mammal SubClassOf: Animal
top = Symbols.new(CLASS, "Thing")
m = Symbols.new(CLASS, "Mammal")
a = Symbols.new(CLASS, "Animal")
mc = AtomicConcept.new(m)
ac = AtomicConcept.new(a)
s1  = ConceptSubsumption.new(mc, ac)

# Class: Birds EquivalentTo: Animal and has_part some Wing
b = Symbols.new(CLASS,"Birds")
w = Symbols.new(CLASS, "Wing")
hp = Symbols.new(ROLE, "has_part")
bc = AtomicConcept.new(b)
wc = AtomicConcept.new(w)
ac2 = AtomicConcept.new(a)
hpr = AtomicObjectProperty.new(hp) # added to get different instances for different occurences
c2 = ExistentialConcept.new(hpr, wc)
c1 = AndConcept.new(ac2, c2)
s2 = ConceptEquivalence.new(bc, c1)

cSet1 = Set[top, a, b, w, m]
oSet1 = Set[hp]
dSet1 = Set[]
iSet1 = Set[]

# InputSpace2
# Class: Mammal SubClassOf: Animal
top1 = Symbols.new(CLASS, "Thing")
m1 = Symbols.new(CLASS, "Mammal")
a1 = Symbols.new(CLASS, "Animal")
mc1 = AtomicConcept.new(m1)
ac1 = AtomicConcept.new(a1)
s11  = ConceptSubsumption.new(mc1, ac1)

# Class: Birds EquivalentTo: Animal and has_part some Wing
b1 = Symbols.new(CLASS,"Birds")
w1 = Symbols.new(CLASS, "Wing")
hp1 = Symbols.new(ROLE, "has_part")
bc1 = AtomicConcept.new(b1)
wc1 = AtomicConcept.new(w1)
ac21 = AtomicConcept.new(a1)
hpr1 = AtomicObjectProperty.new(hp1) # added to get different instances for different occurences
c21 = ExistentialConcept.new(hpr1, wc1)
c11 = AndConcept.new(ac21, c21)
s21 = ConceptEquivalence.new(bc1, c11)

cSet2 = Set[top1, a1, b1, w1, m1]
oSet2 = Set[hp1]
dSet2 = Set[]
iSet2 = Set[]

sigma1 = Signature.new(cSet1,oSet1,dSet1,iSet1)
inputSpace_1 = Ontology.new(sigma1, [s1,s2])
sigma2 = Signature.new(cSet2,oSet2,dSet2,iSet2)
inputSpace_2=Ontology.new(sigma2, [s11,s21])


rs=Array.new
rs= generate_base(inputSpace_1,inputSpace_2) # Calling Method to generate base

# Results after finding Base using Intersection
puts "Resultant Ontology & Morphisms :",""
puts rs
puts "","Resultant Ontology after Intersection",""
rs[0].show
puts "","Resultant Morphism1",""
p rs[1]
puts "","Resultant Morphism2",""
p rs[2]
