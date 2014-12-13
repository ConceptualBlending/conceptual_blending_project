
load '../../../source/data.rb'


   def replace_equivalences(onto)
      sig = onto.o_signature 
      sens = onto.o_sentences  # why did you do this if you set it on next line to []?
      sens =[]

      onto.o_sentences.each do|x|
         if @o_sentences.select{|z| z.is_a?(ConceptEquivalence(a,b))} # the select method gives you a sublist
          # you want to make a test about x (2 lines above) being a ConceptEquivalence
          # look at data.rb, allSubsumption to see how this is done - the argument of is_a is a class name  
            @components = [a,b] # there is no a or b here
            a = components(0) # here you want to take the first element from x.components
            b = components(1)
            y = ConceptSubsumption(a,b) # assuming a and b were correct, here you create a sentence with new, see examples at the end of data.rb
            sens.insert(y) # insert will require another argument, the index where you want to insert
                           # look for a method that inserts at the end of the array!
         else
            sens() # this is unfinished code, you want to add x here at the end of sens
         end
      end
   end



#onto = Ontology.new()
replace_equivalences(onto)
