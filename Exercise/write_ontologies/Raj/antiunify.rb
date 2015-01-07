load 'data.rb'
$top = Symbols.new(CLASS,"Thing")

#INPUT SPACE 1
# Class: A EquivalentTo: B and C

a = Symbols.new(CLASS,"A")
b = Symbols.new(CLASS,"B")
c = Symbols.new(CLASS,"C")
aac = AtomicConcept.new(a)
bac = AtomicConcept.new(b)
cac = AtomicConcept.new(c)
bc  = AndConcept.new(bac,cac)

#INPUT SPACE 2
# Class: A EquivalentTo: B and D

a1 = Symbols.new(CLASS,"A")
b1 = Symbols.new(CLASS,"B")
c1 = Symbols.new(CLASS,"D")
aac1 = AtomicConcept.new(a1)
bac1 = AtomicConcept.new(b1)
cac1 = AtomicConcept.new(c1)
bc1  = AndConcept.new(bac1,cac1)

cSet1 = Set[$top,a,b,c,a1,b1,c1]
oSet1 = Set[]
dSet1 = Set[]
iSet1 = Set[]

sigma1 = Signature.new(cSet1,oSet1,dSet1,iSet1)
onto1 = Ontology.new(sigma1,[])

class Af

  def antiunify(concept1,concept2)

    if concept1.is_a?(AndConcept)
      if concept2.is_a?(AndConcept)
        andresult = AndConcept.new(antiunify(concept1.components[0],concept2.components[0]),antiunify(concept1.components[1],concept2.components[1]))
        return andresult
      else concept2.is_a?(AtomicConcept) || concept2.is_a?(ExistentialConcept)
      puts "\n"
        puts "AntiUnification Not Possible between AND &[ Atomic Concept or Existential Concept ]"
      end
    end

    if concept1.is_a?(AtomicConcept)
      if concept2.is_a?(AndConcept) || concept2.is_a?(ExistentialConcept)
        puts "\n"
        puts "AntiUnification Not Possible between Atomic Concept & [ AND Concept or Existential Concept ]"
      else concept2.is_a?(AtomicConcept)
      res=antiunify(concept1.name,concept2.name)
      s=Symbols.new(CLASS,res)
      return AtomicConcept.new(s)
      end
    end

    if concept1.is_a?(Symbols)  && concept2.is_a?(Symbols)
      c1=concept1.name
      c2=concept2.name
      if c1==c2
        return c1
      else
        return "X"
      end
    end

    if concept1.is_a?(ExistentialConcept)
      if concept2.is_a?(AndConcept) || concept2.is_a?(AtomicConcept)
        puts "\n"
        puts "AntiUnification Not Possible between Existential Concept & [ AND Concept or Atomic Concept ]"
      else concept2.is_a?(ExistentialConcept)
        existresult = ExistentialConcept.new(antiunify(concept1.components[0],concept2.components[0]),antiunify(concept1.components[1],concept2.components[1]))
      return existresult
      end
    end

    if concept1.is_a?(AtomicObjectProperty) && concept2.is_a?(AtomicObjectProperty)
      result=antiunify(concept1.name,concept2.name)
      ac= AtomicObjectProperty.new(result)
      return ac
    end

    if concept1==$top || concept2==$top
      return $top
    end
  end
end

concept1= [bc,$top]
concept2= [bc1]
result =Array.new(200)
concept1.each do |concept1|
  concept2.each do |concept2|
    obj=Af.new
    result=obj.antiunify(concept1,concept2)
        puts result
  end
end
