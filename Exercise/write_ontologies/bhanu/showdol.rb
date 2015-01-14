#!/usr/bin/env ruby

require 'set'
#load '../Pradeep/xmlParse.rb'

###### some constants

CLASS = "owl:Class"
ROLE  = "owl:ObjectProperty"
DATA  = "owl:DatatypeProperty"
INDIVIDUAL = "owl:NamedIndividual"
SUBCLASSOF= "owl:Class/rdfs:subClassOf"

###### Symbols

class Symbols
 
 attr_accessor :kind, :name 

 def initialize(a_kind, a_name)
  case a_kind
  when CLASS, ROLE, DATA, INDIVIDUAL ,SUBCLASSOF
    @kind = a_kind
  else 
    raise "Not a proper kind"
  end
  @name = a_name
 end

 def show
 
 #	 @kind.each do |x|
case @kind
when SUBCLASSOF
puts "SubClassOf:"+@name
when CLASS
puts "Class:"+@name
when ROLE
puts "ObjectProperty:"+@name
when DATA
puts "DatatypeProperty"+@name
when INDIVIDUAL
puts "Individual:"+@name

else
puts "ERROR,false value"+@name
end 
#@name.each do |x|
#puts @name + "\n "
  end


end

#top = Symbols.new(CLASS, "Thing")
#top.show

#err = Symbols.new(3, "a") throws an error

###### Signatures

class Signature 

 attr_accessor :concepts, 
               :objProps,
               :dataProps,
               :individuals

 def initialize(cSet, oSet, dSet, iSet)
  #Todo: check that you only have sets as args
  if cSet.kind_of?(Set) & oSet.kind_of?(Set) & dSet.kind_of?(Set) & iSet.kind_of?(Set)
   @concepts = cSet
   @objProps = oSet
   @dataProps = dSet
   @individuals = iSet
  else
  #Todo: use ruby exception raise. use logger
    puts "wrong data"
  end
  def show 
  @concepts.each do |x|
   x.show
  end
   @objProps.each do |x|
   x.show
  end
  @dataProps.each do |x|
   x.show
  end
  @individuals.each do |x|
   x.show
  end
  end
  
 end

end

cSet = Set[]
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
def show

#@name.each do |x|
 @name.show
end

end

# negation of a concept is a concept


class NegatedConcept < Concept

    def initialize(a_concept)
    @components = [a_concept]
    a_concept.parent = self
    end
end

#a = Symbols.new(CLASS, "A")
#ac = AtomicConcept.new(a)
#nota = NegatedConcept.new(ac)
#p nota
 
# disjunction of a concept is a concept
class OrConcept < Concept

    def initialize(c1,c2)
    @components = [c1, c2]
	c1.parent = self
	c2.parent = self
    end
	def show
	components[0].show 
	print "or " 
	components[1].show
end
end


# conjunction of a concept is a concept
class AndConcept < Concept

	def initialize(c1, c2)
		@components = [c1, c2]
		c1.parent = self
		c2.parent = self
	end
	def show 
	components[0].show
	print "and "
	components[1].show
	#@components.each do |x|
	 #x.show
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
	def show
	components[0].show
	print "some "
    components[1].show
	#@components.each do |x|
	#x.show
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

# DataProperty

class DataProperty < Expression
end

class AtomicDataProperty < DataProperty
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

# R^{-1}
class InverseDataProperty < DataProperty

 def initialize(r)
  @components = [r]
  r.parent = self
 end
end

# role complement

class NegatedDataProperty < DataProperty

 def initialize(r)
   @components = [r]
   r.parent = self  
 end

end

# union of roles

class UnionDataProperty < DataProperty

 def initialize(r1, r2)
   @components = [r1, r2]
   r1.parent = self
   r2.parent = self
 end
end
# conjunction of roles

class ConjunctionDataProperty < DataProperty 

 def initialize(r1,r2)
   @components = [r1, r2]
   r1.parent = self
   r2.parent = self
 end

end

# datatype restriction is missing!

# Object properties

class ObjectProperty < Expression
#puts ObjectProperty
end

class AtomicObjectProperty < ObjectProperty
 attr_accessor :name
 def initialize(x)
  @name = x
 end
 def show
 @name.show
 end
 
end

class InverseObjectProperty < ObjectProperty
 
  def initialize(r)
   @components = r
   r.parent = self
  end
 
end

################ Sentences

class Sentence < Expression
end

# classes 

class ConceptSubsumption < Sentence
 
 def initialize(c1, c2)
   if c1.is_a?(Concept)
	  @components = [c1, c2]
	  c1.parent = self
	  c2.parent = self
   else  
    raise "Waiting for concept here"
   end
   def show
	components[0].show
	#print "SubClassOf:"
components[1].show
 # @components.each do |x|
   #x.show
   # puts "SubClassOf:"   
    #c1.show
	#c2.show
	end
	end
end

# Equivalent concept
class ConceptEquivalence < Sentence
 
 def initialize(c1, c2)
   if c1.is_a?(Concept)
	  @components = [c1, c2]
	  c1.parent = self
	  c2.parent = self
   else  
    raise "Waiting for concept here"
   end
   def show
   components[0].show
	print "EquivalentTo:"
    components[1].show
	puts ''
   #@components.each do |x|
    #x.show
   end
 end
end 

class DisjointUnionOfConcepts < Sentence
 
 def initialize(c1, clist)
  @components = clist.unshift(c1)
  c1.parent = self
  clist.each do |c|
    c.parent = self
  end 
 end

end

# has key?

# object property frame sentences

class DomainAssertion < Sentence

 def initialize(r,c)
   @components = [r,c]
   r.parent = self
   c.parent = self
 end

end

class RangeAssertion < Sentence

 def initialize(r,c)
   @components = [r,c]
   r.parent = self
   c.parent = self
 end

end

class CharacteristicsAssertion < Sentence

  def initialize(r,clist)
    @components = clist.unshift(r)
    r.parent = self
    clist.each do |c|
     c.parent = self
    end 
   # TODO: define Characteristics
   
  end

end

class SubObjectProperty < Sentence

  def initialize(r1, r2)
    @components = [r1, r2]
    r1.parent = self
    r2.parent = self
  end

end

class EquivalentObjectProperty < Sentence
  
  def initialize(r1, r2)
    @components = [r1, r2]
    r1.parent = self
    r2.parent = self
  end
end

class DisjointObjectProperty < Sentence

  def initialize(r1, r2)
    @components = [r1, r2]
    r1.parent = self
    r2.parent = self
  end
end

class InverseOfObjectProperty < Sentence

  def initialize(r1, r2)
    @components = [r1, r2]
    r1.parent = self
    r2.parent = self
  end
end

class SubPropertyChain < Sentence
 
 def initialize(r1, rlist)
  @components = rlist.unshift(r1)
  r1.parent = self
  rlist.each do |r|
    r.parent = self
  end 
 end

end

class DataDomainAssertion < Sentence

 def initialize(r,c)
   @components = [r,c]
   r.parent = self
   c.parent = self
 end

end

class DataRangeAssertion < Sentence

 def initialize(r,c)
   @components = [r,c]
   r.parent = self
   c.parent = self
 end

end

class DataCharacteristicsAssertion < Sentence
  #md is this class repeated by mistake, CharacteristicsAssertion is defined above already. 
  # MC: I changed
  def initialize(r,clist)
   # TODO: define Characteristics
  end

end

class SubDataProperty < Sentence

  def initialize(r1, r2)
    @components = [r1, r2]
    r1.parent = self
    r2.parent = self
  end

end

class EquivalentDataProperty < Sentence
    def initialize(r1, r2)
    @components = [r1, r2]
    r1.parent = self
    r2.parent = self
  end
end

class DisjointDataProperty < Sentence
  def initialize(r1, r2)
    @components = [r1, r2]
    r1.parent = self
    r2.parent = self
  end
end


# roles

class FactAssertion < Sentence
 
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

# Individual: john SameAs: alex
class SameAsAssertion < Sentence
end

# Individual: john DifferentFrom: alex
class DifferentFromAssertion < Sentence
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

 def show
    @o_sentences.each do |x|
        x.show
    end
       @o_signature.show

 end
 
=begin
 def showDoL
   @source_sig.show 
   @target_sig.show
   @symbol_map.show
 end
=end

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

 def showDOL
   puts @source_sig
   puts @target_sig
   @symbol_map.each do |kind,value|
      puts "\n"
     print "\e" ;kind.show ;print "|->" ;value.show
      
   #  puts string 
     
    # puts"->"
     #value.show
     end
 end 
   
end

#o = parseSymbols("../Pradeep/NewBird.owl")
#o.show
# Class: Mammal SubClassOf: Animal
m = Symbols.new(CLASS, "Mammal")
a = Symbols.new(CLASS, "Animal")
mc = AtomicConcept.new(m)
ac = AtomicConcept.new(a)
s1  = ConceptSubsumption.new(mc, ac)

cSet1 = Set[m, a]
oSet1 = Set[]
dSet1 = Set[]
iSet1 = Set[]

sigma1 = Signature.new(cSet1,oSet1,dSet1,iSet1)
onto1 = Ontology.new(sigma1, [s1])
#onto1.show
#p s1

# Class: Birds EquivalentTo: Animal and has_part some Wing

b = Symbols.new(CLASS, "Birds")
w = Symbols.new(CLASS, "Wing")
hp = Symbols.new(ROLE, "has_part")
bc = AtomicConcept.new(b)
wc = AtomicConcept.new(w)
#ac2 = AtomicConcept.new(a)
#hpr = AtomicObjectProperty.new(hp) # added to get different instances for different occurences
c2 = ExistentialConcept.new(hp, wc)
#c1 = AndConcept.new(ac2, c2)
s2 = ConceptEquivalence.new(bc, c2)  

#p s2

cSet1 = Set[b, w]
oSet1 = Set[hp]
dSet1 = Set[]
iSet1 = Set[]

sigma2 = Signature.new(cSet1,oSet1,dSet1,iSet1)
onto2 = Ontology.new(sigma2, [s2])
#onto2.show


mor = Morphism.new(sigma2,sigma1,[[b,w],[m,a]] )
mor.showDOL
