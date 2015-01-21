load 'data.rb'
	

def deleteaxiom(obj1,obj2)
 
    sig1 = obj1.o_signature
    sens1 = obj1.o_sentences
    obj1.o_sentences.each do |k|
     a = k.components[0]
    
     b = k.components[1]
end
    x = Ontology.new(sig1, sens1)
	
    sig2 = obj2.o_signature
    sens2 = obj2.o_sentences
    obj1.o_sentences.each do |k|
     a = k.components[0]
    
     b = k.components[1]
end
    y = Ontology.new(sig2, sens2)
    list = [x,y]
	puts ("list of Axioms")
    puts list
    random = rand(list.length)
   	list.delete_at(random)
	return list
    	
 
end

 #Class: A SubClassOf: B

A= Symbols.new(CLASS, "A")
B = Symbols.new(CLASS, "B")
Ac = AtomicConcept.new(A)
Bc = AtomicConcept.new(B)
s1  = ConceptSubsumption.new(Ac, Bc)

 #Class: E SubClassOf: F

E= Symbols.new(CLASS, "E")
F = Symbols.new(CLASS, "F")
Ec = AtomicConcept.new(E)
Fc = AtomicConcept.new(F)
s3  = ConceptSubsumption.new(Ec, Fc)

cSet1 = Set[A, B, E, F]
oSet1 = Set[]
dSet1 = Set[]
iSet1 = Set[]

sigma1 = Signature.new(cSet1,oSet1,dSet1,iSet1)
onto1 = Ontology.new(sigma1, [s1, s3])

 #Class: D EquivalentTo: C
 
 C = Symbols.new(CLASS, "C")
 D = Symbols.new(CLASS,"D")
 Cc = AtomicConcept.new(C)
 Dc = AtomicConcept.new(D)
 s2 = ConceptEquivalence.new(Bc, Cc)

 #Class: K SubClassOf: I

K= Symbols.new(CLASS, "K")
I = Symbols.new(CLASS, "I")
Kc = AtomicConcept.new(K)
Ic = AtomicConcept.new(I)
s4  = ConceptSubsumption.new(Kc, Ic)

cSet2 = Set[D, C, K, I]
oSet2 = Set[]
dSet2 = Set[]
iSet2 = Set[]

sigma2 = Signature.new(cSet2,oSet2,dSet2,iSet2)
onto2 = Ontology.new(sigma2, [s2, s4])

del = deleteaxiom(onto1,onto2)
puts("Resulting Axiom after deleting a random element")
puts del

