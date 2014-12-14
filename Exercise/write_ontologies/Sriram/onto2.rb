

load '../../../source/data.rb'


class Replace

   def initialize(obj)
      sig = obj.o_signature
   end

   def repConcept(obj)
      sens = [ ]   
      obj.o_sentences.each do|x|
         if x.is_a?(ConceptEquivalence) 
            @components = x 
            a = x.components[0] 
            b = x.components[1]
            y = ConceptSubsumption.new(a, b) 
            sens.push(y) 
            p sens
         end  
      end
   end
end

 #Class: Mammal SubClassOf: Animal

m = Symbols.new(CLASS, "Mammal")
m.show
a = Symbols.new(CLASS, "Animal")
a.show
mc = AtomicConcept.new(m)
ac = AtomicConcept.new(a)
s1  = ConceptEquivalence.new(mc, ac)


cSet1 = Set[a, m]
oSet1 = Set[]
dSet1 = Set[]
iSet1 = Set[]

sigma1 = Signature.new(cSet1,oSet1,dSet1,iSet1)
onto1 = Ontology.new(sigma1, [s1])
