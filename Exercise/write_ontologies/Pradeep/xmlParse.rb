require 'set'
require 'rexml/document'
include REXML
load 'data.rb'
   def parseSymbols()
      cSet = Set[]
      dSet = Set[]
      cs1 = []
      doc = Document.new(File.new("animal.owl"))
      root = doc.root
      doc.elements.each("rdf:RDF/owl:Class") do |i|  # Parse Classes
         string = element_about(i, "about")
         symClass = Symbols.new(CLASS, string)
#        p symClass
         acClass = AtomicConcept.new(symClass)
         cSet = Set[acClass]
         doc.elements.each("rdf:RDF/owl:Class/rdfs:subClassOf") do |i| # Parse Sub Classes
            subString = element_about(i, "resource" )
            symSubClass = Symbols.new(CLASS, subString)
#           p symSubClass
            acSubClass = AtomicConcept.new(symSubClass)
            cs1 = ConceptSubsumption.new(acClass, acSubClass)
#           p cs1
         end
      end
      doc.elements.each("rdf:RDF/owl:ObjectProperty") do |i| # Parse ObjectProperty 
         objString = element_about(i, "about")
         symObjProp = Symbols.new(ROLE, objString)
         dSet = [symObjProp]
         acObjProp = AtomicConcept.new(symObjProp)
      end
      dSet1 = Set[]
      iSet1 = Set[]
      sig = Signature.new(cSet, dSet, dSet1, iSet1)
      onto1 = Ontology.new(sig, cs1)
      p onto1
   end

   def element_attr(e, attr)
      return e.attributes[attr][0,100000000]
   end

   def element_about(e, text)
      if text.eql? "about"
         return element_attr(e, "about")
      end

      if text.eql? "resource"
      if text.eql? "resource"
         return element_attr(e, "resource")
      end
   end
end

top = ParseOntology.new()
top.parseSymbols
