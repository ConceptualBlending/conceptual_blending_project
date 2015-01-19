load 'bhanu.rb'


def deleteaxiom(obj)


 sens = obj.o_sentences

	obj.o_sentences.each do|i|
    a = i.components[0]
	b = i.components[1]
	end
	list = Array(sens)
	puts ("list of sentence")
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

 #Class: B EquivalentTo: C
 
 C = Symbols.new(CLASS, "C")
 Cc = AtomicConcept.new(C)
 Bc1 = AtomicConcept.new(B)
 s2 = ConceptEquivalence.new(Bc, Cc)

cSet1 = Set[A, B, C]
oSet1 = Set[]
dSet1 = Set[]
iSet1 = Set[]

sigma1 = Signature.new(cSet1,oSet1,dSet1,iSet1)
onto1 = Ontology.new(sigma1, [s1, s2])
del = deleteaxiom(onto1)
puts("list of sentences after deleting a random element")
puts del 
