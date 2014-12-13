
load 'data.rb'


class Ontology

   attr_accessor :o_signature, :o_sentences
   def initialize(sig,sens)
      @onto.o_signature = sig
      @onto.o_sentences = sens
   end

   def replace_equivalences(onto)
      sig = onto.o_signature 
      sens = onto.o_sentences
      sens =[]

      onto.o_sentences.each do|x|
         if @o_sentences.select{|x| x.is_a?(ConceptEquivalence(a,b))}
            @components = [a,b]
            a = components(0)
            b = components(1)
            y = ConceptSubsumption(a,b)
            sens.insert(y)
         else
            sens()
         end
      end
   end
end


onto = Ontology.new()
onto.replace_equivalances
