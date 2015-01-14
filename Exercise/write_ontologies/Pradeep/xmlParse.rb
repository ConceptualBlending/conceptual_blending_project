require 'set'
require 'rexml/document'
include REXML
#load '../../../source/data.rb'
#load '../bhanu/pp.rb'

AND = "intersectionOf"
OR  = " "
MIN = " "
MAX = " "
SOME = "Restriction"

   def parseSymbols(file)
      cSet = Set[] 
      dSet = Set[]
      dSet1 = Set[]
      sens = []
      acClass = []
      symArr = []
      acSubClass = []
      cs1 = []
      s = []
      acAndStr = []
      andString = []
      a = []
      ecConcept = []    
      proString = []
      acSomeString = []
      andStr = [] 
      doc = Document.new(File.new(file))

      root = doc.root
      doc.elements.each("rdf:RDF/owl:Class") do |i|  # Parse Classes
         string = element_about(i, "about")
         symClass = Symbols.new(CLASS, string)
         acClass = AtomicConcept.new(symClass)
         cSet.add(symClass)
      end

      doc.elements.each("rdf:RDF/owl:Class/rdfs:subClassOf") do |i| # Parse Sub Classes
         if !i.attributes["resource"].nil?
            prntString = element_about(i.parent, "about" )
            subString = element_about(i, "resource")
         else 
            i.each_recursive do |child|
                s = child
            end
            s = s.parent
           # puts s.name.to_s
            begin
               case s.name.to_s
                  when AND
                       s.elements.each("rdf:Description") do |i|
                          andString = element_about(i, "about")
                          symStr = Symbols.new(CLASS,andString)
                          acStr = AtomicConcept.new(symStr)
                          andStr = AndConcept.new(acStr, ecConcept)
                       end         
                  when OR
                       puts "OR :"+s.name.to_s
                  when MAX
                       puts "MAX :"+s.name.to_s
                  when MIN
                       puts "MIN :"+s.name.to_s
                  when SOME
                       s.elements.each("owl:onProperty") do |i|
                          proStr = element_about(i, "resource")
                          proString = Symbols.new(ROLE,proStr)
                       end
                       s.elements.each("owl:someValuesFrom") do |i|
                          someString = element_about(i, "resource")
                          symSomStr = Symbols.new(CLASS,someString)   
                          acSomeString = AtomicConcept.new(symSomStr)
                       end
                       ecConcept = ExistentialConcept.new(proString ,acSomeString)
   
                  else
                       puts "Else part : "+s.name.to_s
                       puts "None"
               end
               s = s.parent
               a = s.name.to_s
               #puts a 
            end until a.eql? "Class"            
            s = parseTree(s, "subClassOf")
=begin
=end 
               sub = s.parent
               subname = sub.name.to_s
               if subname.eql? "Class"  
                  prntString = element_about(sub, "about" )
                  symPrntClass = Symbols.new(prntString)
                  acprntClass = AtomicConcept.new(symPrntClass) 
                  puts acprntClass
               end
         end
=begin
         symPrntClass = Symbols.new(CLASS, prntString)
         symSubClass = Symbols.new(SUBCLASSOF, subString) 
         acprntClass = AtomicConcept.new(symPrntClass)
         acSubClass = AtomicConcept.new(symSubClass)
=end  
         puts andStr
         puts acprntClass
#         cs1 = ConceptSubsumption.new(andStr, acprntClass)
#         sens.push(cs1)
      end

      doc.elements.each("rdf:RDF/owl:ObjectProperty") do |i| # Parse ObjectProperty 
         objString = element_about(i, "about")
         symObjProp = Symbols.new(ROLE, objString)
         acObjProp = AtomicConcept.new(symObjProp)
         dSet.add(symObjProp)
      end

      doc.elements.each("rdf:RDF/owl:DatatypeProperty") do |i| # Parse dataProperty 
         dataString = element_about(i, "about")
         symdataProp = Symbols.new(DATA, dataString)
         acdataProp = AtomicConcept.new(symdataProp)
         dSet1.add(symdataProp)
      end

      iSet1 = Set[]
      sig = Signature.new(cSet, dSet, dSet1, iSet1)
      onto1 = Ontology.new(sig, sens)
      return onto1
   end

   def parseTree(node, string)
      begin
#         puts string
         puts node.name.to_s
         node = node.parent
         nodename = node.name.to_s
      end until nodename.eql? string
      return node
   end

   def self.element_attr(e, attr)
      return e.attributes[attr][0,1000]
   end

   def self.element_about(e, text)
         if text.eql? "about"
            return element_attr(e, "about")
         end

         if text.eql? "resource"
            return element_attr(e, "resource")
         end
   end


#o = parseSymbols("animal.owl")
#p o.o_signature.concepts.size
#p o.o_sentences.size
