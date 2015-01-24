load 'data.rb'
	

def list(var)
    random = rand(var.length)
	var.delete_at(random)
	return var
end    
def deleteaxiom(obj1,obj2)
    
    sig1 = obj1.o_signature
    sens1 = obj1.o_sentences
	l1 = list(sens1)
    sig2 = obj2.o_signature
    sens2 = obj2.o_sentences
	l2 = list(sens2)
    ont1 = Ontology.new(sig1,l1)
    ont2 = Ontology.new(sig2,l2)
    ar = [ont1,ont2]
	return ar
end

 #Class: A SubClassOf: B

A= Symbols.new(CLASS, "A")
B = Symbols.new(CLASS, "B")
Ac = AtomicConcept.new(A)
Bc = AtomicConcept.new(B)
s1  = ConceptSubsumption.new(Ac, Bc)

 #Class: E SubClassOf: F

E = Symbols.new(CLASS, "E")
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

K = Symbols.new(CLASS, "K")
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
puts("Selected Axioms")
puts del

