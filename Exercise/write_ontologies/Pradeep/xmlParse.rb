require 'set'
require 'rexml/document'
include REXML
#load '../../../source/data.rb'
#load '../bhanu/pp.rb'

   def parseSymbols(file)
      cSet = Set[] 
      dSet = Set[]
      dSet1 = Set[]
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
         symSubClass = Symbols.new(SUBCLASSOF, subString) 
		puts symSubClass
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
