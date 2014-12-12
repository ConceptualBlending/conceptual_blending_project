require 'set'
require 'rexml/document'
include REXML
load 'data.rb'


   def parseSymbols(file)
      cSet = Set[] 
      dSet = Set[]
      sens = []
      acClass = []
      symArr = []
      acSubClass = []
      cs1 = []
      doc = Document.new(File.new(file))

      root = doc.root
      doc.elements.each("rdf:RDF/owl:Class") do |i|  # Parse Classes
         string = element_about(i, "about")
         symClass = Symbols.new(CLASS, string)
         acClass = AtomicConcept.new(symClass)
         cSet.add(symClass)
      end

      doc.elements.each("rdf:RDF/owl:Class/rdfs:subClassOf") do |i| # Parse Sub Classes
         prntString = element_about(i.parent, "about" )
         subString = element_about(i, "resource")

         symPrntClass = Symbols.new(CLASS, prntString)
         symSubClass = Symbols.new(CLASS, subString) 

         acprntClass = AtomicConcept.new(symPrntClass)
         acSubClass = AtomicConcept.new(symSubClass)
     
         cs1 = ConceptSubsumption.new(acSubClass, acprntClass)
         sens.push(cs1)
      end

      doc.elements.each("rdf:RDF/owl:ObjectProperty") do |i| # Parse ObjectProperty 
         objString = element_about(i, "about")
         symObjProp = Symbols.new(ROLE, objString)
         acObjProp = AtomicConcept.new(symObjProp)
         dSet.add(symObjProp)
      end

      dSet1 = Set[]
            iSet1 = Set[]
      sig = Signature.new(cSet, dSet, dSet1, iSet1)
      onto1 = Ontology.new(sig, sens)
       p onto1
      return onto1
   end

   def self.element_attr(e, attr)
      return e.attributes[attr][0,10000]
   end

   def self.element_about(e, text)
      if text.eql? "about"
         return element_attr(e, "about")
      end

      if text.eql? "resource"
         return element_attr(e, "resource")
      end
   end


o = parseSymbols("animal.owl")
p o.o_signature.concepts.size
p o.o_sentences.size
