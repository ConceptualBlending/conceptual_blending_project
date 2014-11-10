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

#err = Symbols.new(3, "a") throws an error

###### Signatures

class Signature 

 attr_accessor :concepts, 
               :objProps,
               :dataProps,
               :individuals

 def initialize(cSet, oSet, dSet, iSet)
  #Todo: check that you only have sets as args
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
class Expression
         attr_accessor :components, :parent
		
end

# concept is an expression 
class Concept < Expression
end

# atomic concept is a concept
class AtomicConcept < Concept
 
 attr_accessor :name
 
 def initialize(a_symbol)
  @components = []			
  if a_symbol.is_a?(Symbols)
   @name = a_symbol
  else 
   raise "Symbol expected"
  end
 end

end

# negation of a concept is a concept


class NegatedConcept < Concept

    def initialize(a_concept)
    @components = [a_concept]
    a_concept.parent = self
    end
end
a = Symbols.new(CLASS, "A")
ac = AtomicConcept.new(a)
nota = NegatedConcept.new(ac)
p nota
 
# disjunction of a concept is a concept
class OrConcept < Concept

    def initialize(c1,c2)
    @components = [c1, c2]
	c1.parent = self
	c2.parent = self
     end
 end

# conjunction of a concept is a concept
class AndConcept < Concept

	def initialize(c1, c2)
		@components = [c1, c2]
		c1.parent = self
		c2.parent = self
	end
end

# universal restriction on a concept by a role is a concept
class UniversalConcept < Concept

  def initialize(a_role, a_concept)
    @components = [a_role, a_concept]   
	a_concept.parent = self
  end
end

# existential restriction on a concept by a role is a concept
class ExistentialConcept < Concept

	def initialize(a_role, a_concept)
		@components = [a_role, a_concept]	
		a_concept.parent = self
	end
end

# minimum cardinality
class MinConcept < Concept
 
  attr_accessor :cardinality

  def initialize(a_role, a_cardinality, a_concept)
    @components = [a_role, a_concept]   
    @cardinality = a_cardinality
	a_concept.parent = self
  end
end


# maximum cardinality
class MaxConcept < Concept
 
  attr_accessor :cardinality

  def initialize(a_role, a_cardinality, a_concept)
    @components = [a_role, a_concept]   
    @cardinality = a_cardinality
	a_concept.parent = self
  end
end


# exact cardinality
class ExactConcept < Concept
 
  attr_accessor :cardinality

  def initialize(a_role, a_cardinality, a_concept)
    @components = [a_role, a_concept]   
    @cardinality = a_cardinality
	a_concept.parent = self
  end
end



################ Sentences

class Sentence < Expression
end

class ConceptSubsumption < Sentence
 
 def initialize(c1, c2)
   if c1.is_a?(Concept)
	@components = [c1, c2]
	c1.parent = self
	c2.parent = self
   else  
    raise "Waiting for concept here"
   end
 end
end

#each_a_is_b = ConceptSubsumption.new(ac, bc)
#p each_a_is_b

# class RoleSubsumption TODO

class RoleAssertion < Sentence
 
 def initialize(i1, r, i2)
   @components = [i1, r, i2]
 end

end

class TypeAssertion < Sentence

 def initialize(i,c)
   @components = [i, c]
	c.parent = self
 end
end

#i1 = Symbols.new(ROLE, "i1")
#i1_is_nota = TypeAssertion.new(i1, nota)



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

#onto = Ontology.new(sigma, [each_a_is_b,i1_is_nota])
# it is possible to put a sentence in an ontology
# even if it uses a symbol that is not in the signature
# we need a test for that!

#p onto.o_sentences

#subs = onto.all_subsumptions # second sentence won't be displayed

#onto.all_subsumptions.each {|x| p x.subsumed_concept} #dynamic typing => no casts

####### Morphism

class Morphism 

 attr_accessor :source_sig, :target_sig, :symbol_map

 def initialize(ssig, tsig, smap)
   @source_sig = ssig
   @target_sig = tsig
   @symbol_map = smap
 end 

end
