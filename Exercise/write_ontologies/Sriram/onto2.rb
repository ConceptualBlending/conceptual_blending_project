
load '\..\..\..\source\data.rb'


   def repConcept(obj)
      sig = obj.o_signature
	  sens = [ ]   
      obj.o_sentences.each do|x|
         if x.is_a?(ConceptEquivalence) 
            a = x.components[0] 
            b = x.components[1]
            y = ConceptSubsumption.new(a, b) 
            sens.push(y) 
          else 
		    sens.push()
         end  
      end
   end


  
   
 #Class: A SubClassOf: B

A= Symbols.new(CLASS, "A")
B = Symbols.new(CLASS, "B")
Ac = AtomicConcept.new(A)
Bc = AtomicConcept.new(B)
s1  = ConceptSubsumption.new(Ac, Bc)

 #Class: B EquivalentTo: C
 
 C = Symbols.new(CLASS, "C")
 Cc = AtomicConcept.new(C)
 s2 = ConceptEquivalence.new(Bc, Cc)

cSet1 = Set[A, B, C]
oSet1 = Set[]
dSet1 = Set[]
iSet1 = Set[]

sigma1 = Signature.new(cSet1,oSet1,dSet1,iSet1)
onto1 = Ontology.new(sigma1, [s1, s2])


onto2 = repConcept(onto1)

p onto2
