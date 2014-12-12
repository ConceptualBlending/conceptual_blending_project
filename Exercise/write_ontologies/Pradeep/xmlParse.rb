require 'set'
require 'rexml/document'
include REXML
load '../../../source/data.rb'

   def parseSymbols(file)
      cSet = Set[]
      dSet = Set[]
      sens = []
      acClass = []
      symArr = []
      acSubClass = []
      doc = Document.new(File.new(file))

      root = doc.root
      doc.elements.each("rdf:RDF/owl:Class") do |i|  # Parse Classes
         string = element_about(i, "about")
         symClass = Symbols.new(CLASS, string)
#        p symClass
         acClass = AtomicConcept.new(symClass)
         cSet.add(symClass)
      end

      doc.elements.each("rdf:RDF/owl:Class/rdfs:subClassOf") do |i| # Parse Sub Classes
         subString = element_about(i, "resource" )
         symSubClass = Symbols.new(CLASS, subString)
#        p symSubClas
         acSubClass = AtomicConcept.new(symSubClass)
      end

      cs1 = ConceptSubsumption.new(acClass, acSubClass)
      sens.push(cs1)
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
      # p onto1
      return onto1
   end

o = parseSymbols("animal.owl")
p o.o_signature.concepts.size
p o.o_sentences.size
                                 
