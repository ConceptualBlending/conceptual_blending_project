require 'set'

require 'rexml/document'
include REXML
#load '../../../source/data.rb'
#load '../bhanu/pp.rb'

################################################################
# Name : parseSymbols
# 
# Attributes : REXML file
# 
# Action : Parse the file from top to bottom.
#
###############################################################

def parseSymbols(file)
   newchild = []
   classnode = []
   symPrntClass = []
   acSubClass = []
   acClass = []
   cSet = Set[]
   dSet = Set[]
   dSet1 = Set[]
   sens = []

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
      acprntString = Symbols.new(CLASS, prntString)
      acprntClass = AtomicConcept.new(acprntString)
      # Simple subclass without any complex terms in dept
      if !i.attributes["resource"].nil?
         subString = element_about(i, "resource")
         symSubClass = Symbols.new(CLASS, subString) 
         acSubClass = AtomicConcept.new(symSubClass)
         cs1 = ConceptSubsumption.new(acSubClass, acprntClass)
         sens.push(cs1)

      else # subclass with some complex terms
         i.each_recursive do |child|
            newchild = child
         end
            acsubClass = elementMatch(newchild)
            cs1 = ConceptEquivalence.new(acprntClass, acsubClass)
            sens.push(cs1)
      end   
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

################################################################
# Name : elementMatch
# 
# Attributes : node of a tree
# 
# Action : Check the node (which is child node of xml tree) and 
#          recursively goes to parent of the child by maintaining 
#          the count and datastructures in an array. 
#
###############################################################

def self.elementMatch(i)
   ecConcept = []
   andConcept = []
   count = 0
   nodeElement = Array.new()
   begin
      if i.elements
         i.elements.each do |i|
            case i.name.to_s

            when "Restriction"  
               if nodeElement.length == count
                  rescount = count
                  rescount -= 2
                  res1 = nodeElement[rescount]
                  rescount -= 1
                  res2 = nodeElement[rescount]
                  ecConcept = ExistentialConcept.new(res2, res1)
                  nodeElement.push(ecConcept)
                  count += 1 
               end

            when "intersectionOf"
               if nodeElement.length == count
                  intercount = count
                  inter1 = nodeElement[intercount -=1]
                  inter2 = nodeElement[intercount -=1]
                  andConcept = AndConcept.new(inter2, inter1) 
                  nodeElement.push(andConcept)
                  count += 1
               end

            when "onProperty"
               if nodeElement.length == count
                  propElement = element_about(i, "resource")
                  propString = Symbols.new(ROLE,propElement)
                  nodeElement.push(propString)
                  count += 1
               end

            when "someValuesFrom"
               if nodeElement.length == count
                  someElement = element_about(i, "resource")
                  symSomStr = Symbols.new(CLASS,someElement)
                  acSomeString = AtomicConcept.new(symSomStr)
                  nodeElement.push(acSomeString)
                  count +=1 
               end

            when "Description"
               if nodeElement.length == count
                  disElement = element_about(i, "about")
                  symStrElement = Symbols.new(CLASS,disElement)
                  acStrElement = AtomicConcept.new(symStrElement)
                  nodeElement.push(acStrElement) 
                  count += 1
               end

            else 
               puts "Not found in elementMatch"
            end 
         end     
      i = i.parent
      iname = i.name.to_s
      end until iname.eql? "subClassOf"
      return nodeElement[nodeElement.length - 1]
   end
end

################################################################
# Name : previousElement
# 
# Attributes : node of a tree
# 
# Action : Check the node (which is child node of xml tree) and 
#          recursively goes to the other previous node of same 
#          parent
#
###############################################################

def self.previousElement(child)
   if child.previous_element
      child = child.previous_element
   end
   return child
end

################################################################
# Name : element_attr
# 
# Attributes : node and text( attribute of node )
# 
# Action : Get the attributes of the node
#
###############################################################

def self.element_attr(e, attr)
   return e.attributes[attr][0,1000]
end

################################################################
# Name : element_about
# 
# Attributes : node and text (attributes of node)
# 
# Action : check the text (attribute of node) 
#
###############################################################

def self.element_about(e, text)
   if text.eql? "about"
      return element_attr(e, "about")
   end

   if text.eql? "resource"
      return element_attr(e, "resource")
   end
end
      
