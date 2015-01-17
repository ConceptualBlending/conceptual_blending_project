require 'set'

require 'rexml/document'
include REXML
#load '../../../source/data.rb'
#load '../bhanu/pp.rb'


def demoxml(file)
   newchild = []
   classnode = []
   doc = Document.new(File.new(file))
   root = doc.root
   doc.elements.each("rdf:RDF/owl:Class") do |i|  # Parse Classes
      string = element_about(i, "about")
      classnode = string
   end

   doc.elements.each("rdf:RDF/owl:Class/rdfs:subClassOf") do |i| # Parse Sub Classes
      if !i.attributes["resource"].nil?
         prntString = element_about(i.parent, "about" )
         subString = element_about(i, "resource")
#         puts "Parent Class :"+prntString
#         puts "SubClass     :"+subString
      else
         i.each_recursive do |child|
            newchild = child           #Get the child node "someValuesFrom"
         end
             elementMatch(newchild)
      end
   end 
end

def self.elementMatch(i)
   #puts i.name.to_s
   ecConcept = []
   andConcept = []
   count = 0
   nodeElement = Array.new()
   puts "element passed : "+i.name.to_s
   begin
      if i.elements
         i.elements.each do |i|
            puts "Start of Loop : "+i.name.to_s              
            case i.name.to_s

            when "Restriction"
               puts "checked in Restriction"  
               if nodeElement.length == count
                  rescount = count
                  rescount -= 1
                  res1 = nodeElement[rescount]
                  rescount -= 1
                  res2 = nodeElement[rescount]
                  ecConcept = ExistentialConcept.new(res1, res2)
                  nodeElement.push(ecConcept)
                  count += 1 
               end

            when "intersectionOf"
               puts "checked in intersectionOf"
               if nodeElement.length == count
                  intercount = count
                  inter1 = nodeElement[intercount -=1]
                  inter2 = nodeElement[intercount -=1]
                  andConcept = AndConcept.new(inter1, inter2) 
                  nodeElement.push(andConcept)
                  count += 1
               end

            when "onProperty"
               puts "checked in onProperty"
               if nodeElement.length == count
                  propElement = element_about(i, "resource")
                  propString = Symbols.new(ROLE,propElement)
                  nodeElement.push(propString)
                  count += 1
               end

            when "someValuesFrom"
               puts "checked in someValuesFrom"
               if nodeElement.length == count
                  someElement = element_about(i, "resource")
                  symSomStr = Symbols.new(CLASS,someElement)
                  acSomeString = AtomicConcept.new(symSomStr)
                  nodeElement.push(acSomeString)
                  count +=1 
               end

            when "Description"
               puts "checked in Discription"
               if nodeElement.length == count
                  disElement = element_about(i, "about")
                  symStrElement = Symbols.new(CLASS,disElement)
                  acStrElement = AtomicConcept.new(symStrElement)
                  nodeElement.push(acStrElement) 
                  count += 1
               end

            else 
               puts "Not found in elementMatch"
               puts i.name.to_s
            end 
         end     
      i = i.parent
      iname = i.name.to_s
      puts "End of Loop : "+i.name.to_s
      end until iname.eql? "Class"
   end
end
=begin 
def self.childelementMatch(node)
   nodeElement = Array.new
   propString = []
   symStr = []
   if node.elements
      node.elements.each do |i|
         case i.name.to_s
       
         when "onProperty"
            puts "checked in onProperty"
            propElement = element_about(i, "resource")
            proString = Symbols.new(ROLE,propElement)
            nodeElement.push(propString)
         when "someValuesFrom"
            puts "checked in someValuesFrom"
            someElement = element_about(i, "resource")
            symSomStr = Symbols.new(CLASS,someElement)
            acSomeString = AtomicConcept.new(symSomStr)
            nodeElement.push(acSomeString)
         when "Description"
            puts "checked in Discription"
            disElement = element_about(i, "about")
            symStrElement = Symbols.new(CLASS,disElement)
            acStrElement = AtomicConcept.new(symStrElement)
            nodeElement.push(acStrElement)
         else 
            puts "Not found in child elementmatch"
            puts i.name.to_s
         end
      end
      return nodeElement
   end 
end 
=end


def self.previousElement(child)
   if child.previous_element
      child = child.previous_element
   end
   return child
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
      
