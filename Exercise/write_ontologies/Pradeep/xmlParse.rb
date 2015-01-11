require 'set'
require 'rexml/document'
include REXML
#load '../../../source/data.rb'
#load '../bhanu/pp.rb'

AND = "intersectionOf"
OR  = 
MIN =
MAX =
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
            puts s.name.to_s
            begin
               case s.name.to_s
                  when AND
                       s.elements.each("rdf:Description") do |i|
                          andString = element_about(i, "about")
                          symStr = Symbols.new(CLASS,andString)
                          acStr = AtomicConcept.new(symStr)
#                          andStr = AndConcept.new(acStr, ecConcept)
                       end         
                  when OR
                  when MAX
                  when MIN
                  when SOME
                       s.elements.each("owl:onProperty") do |i|
                          proString = elemen_about(i, "resource")
                       end
                       s.elements.each("owl:someValuesFrom") do |i|
                          someString = element_about(i, "resource")
                          symSomStr = Symbols.new(CLASS,someString)   
                          acSomeString = AtomicConcept.new(someString)
                       end
                       ecConcept = ExistentialConcept.new(acSomeString ,acsomeString)
                  else
                       puts "None"
               end
               s = s.parent
               a = s.name.to_s
            end until a.eql? "Class"
            s = parseTree(s, "subClassOf")
            puts s.previous_sibling
=begin
            if s.attributes["resource"].nil?
               s = s.parent
              # puts s.name.to_s
            end
#            subString = element_about(s, "resource")            
=end
            sub = s.parent
            subname = sub.name.to_s
            puts subname
            if subname.eql? "subClassOf"  
               sub = parseTree(sub, "Class")
               prntString = element_about(sub, "about" )
            end       
         end
=begin
         symPrntClass = Symbols.new(CLASS, prntString)
         symSubClass = Symbols.new(SUBCLASSOF, subString) 
		puts symSubClass
         acprntClass = AtomicConcept.new(symPrntClass)
         acSubClass = AtomicConcept.new(symSubClass)
         cs1 = ConceptSubsumption.new(acSubClass, acprntClass)
         sens.push(cs1)
=end
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
