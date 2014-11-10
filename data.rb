#!/usr/bin/env ruby

require 'set'

###### some constants

CLASS = "owl:Class"
ROLE  = "owl:ObjectProperty"
DATA  = "owl:DatatypeProperty"
INDIVIDUAL = "owl:NamedIndividual"

###### Symbols

class Symbols 
 
 attr_accessor :kind, :name 

 def initialize(a_kind, a_name)
  case a_kind
  when CLASS, ROLE, DATA, INDIVIDUAL 
    @kind = a_kind
  else 
    raise "Not a proper kind"
  end
  @name = a_name
 end


 def show 
   puts "Kind: #{@kind} name: #{@name}"
 end
end

top = Symbols.new(CLASS, "Thing")
top.show

#err = Symbols.new(3, "a") #throws an error

###### Signatures

class Signature 

 attr_accessor :concepts, 
               :objProps,
               :dataProps,
               :individuals

 def initialize(cSet, oSet, dSet, iSet)
   @concepts = cSet
   @objProps = oSet
   @dataProps = dSet
   @individuals = iSet
 end

end

cSet = Set[top]
oSet = Set[]
dSet = Set[]
iSet = Set[]

sigma = Signature.new(cSet,oSet,dSet,iSet)

#p sigma

################ Concepts

class Concept
end

class AtomicConcept < Concept
 
 attr_accessor :name
 
 def initialize(a_symbol)
  if a_symbol.is_a?(Symbols)
   @name = a_symbol
  else 
   raise "Symbol expected"
  end
 end

end

a = Symbols.new(CLASS, "A")
b = Symbols.new(CLASS, "B")
r = Symbols.new(ROLE, "R")

thing = AtomicConcept.new(top)
#p thing

ac = AtomicConcept.new(a)

bc = AtomicConcept.new(b)


#test = AtomicConcept.new(sigma)
# this should be illegal

class NegatedConcept < Concept
 attr_accessor :neg_concept

 def initialize(a_concept)
   @neg_concept = a_concept
 end
end

nota = NegatedConcept.new(ac)

#p nota

AND = "owl:intersectionOf"
OR = "owl:unionOf"

class BinaryConcept < Concept 
 attr_accessor :left_concept, :right_concept, :operator

 def initialize(c1,c2,o) 
  @left_concept = c1
  @right_concept = c2
  @operator = o
 end

end

a_and_b = BinaryConcept.new(ac, bc, AND)

#p a_and_b

SOME = "owl:someValuesFrom"
ONLY = "owl:onlyValuesFrom"
MIN  = "owl:minQualifiedCardinality"
MAX  = "owl:maxQualifiedCardinality"
EXACTLY = "owl:qualifiedCardinality"

class RestrictionConcept < Concept
 
  attr_accessor :role, :restriction, :concept

  def initialize(a_role, a_restr,a_concept)
    @role = a_role
    @restriction = a_restr
    @concept = a_concept
  end

end

some_r_a = RestrictionConcept.new(r, SOME, ac)
#p some_r_a 

#exactly_5_r_a = RestrictionConcept.new(r, Restriction.new(EXACTLY, 5), ac) # need a new class here

################ Sentences

class Sentence
end

class ConceptSubsumption < Sentence
 
 attr_accessor :subsumed_concept, :subsuming_concept

 def initialize(c1, c2)
   if c1.is_a?(Concept)
    @subsumed_concept = c1
    @subsuming_concept = c2
   else  
    raise "Waiting for concept here"
   end
 end
end

each_a_is_b = ConceptSubsumption.new(ac, bc)
#p each_a_is_b

# class RoleSubsumption TODO

class RoleAssertion < Sentence
 
 attr_accessor :first_ind, :second_ind, :role

 def initialize(i1, i2, r)
   @first_ind = i1
   @second_ind = i2
   @role = r
 end

end

class TypeAssertion < Sentence

 attr_accessor :ind, :type_concept

 def initialize(i,c)
   @ind = i
   @type_concept = c
 end
end

i1 = Symbols.new(ROLE, "i1")
i1_is_nota = TypeAssertion.new(i1, nota)



############## Ontology 
class Ontology 

 attr_accessor :o_signature, :o_sentences

 def initialize(sigma, sen)
  @o_signature = sigma
  @o_sentences = sen
 end

 def all_subsumptions
   @o_sentences.select{|x| x.is_a?(ConceptSubsumption)}
 end

end

onto = Ontology.new(sigma, [each_a_is_b,i1_is_nota])
# it is possible to put a sentence in an ontology
# even if it uses a symbol that is not in the signature
# we need a test for that!

p onto.o_sentences

subs = onto.all_subsumptions # second sentence won't be displayed

onto.all_subsumptions.each {|x| p x.subsumed_concept} #dynamic typing => no casts

####### Morphism

class Morphism 

 attr_accessor :source_sig, :target_sig, :symbol_map

 def initialize(ssig, tsig, smap)
   @source_sig = ssig
   @target_sig = tsig
   @symbol_map = smap
 end 

 ## symbol map should be a list of pairs (source_symbol, target_symbol)

end
