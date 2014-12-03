require 'rexml/document'
include REXML
load 'data.rb'

def xmlParseText(matchString, type)
    string = ""
   doc = Document.new(File.new("root-ontology.owl"))
   root = doc.root
   if type.eql? "Text"
      doc.elements.each(matchString) do |i|
         string << "\n "<< i.text
      end
   end
   if type.eql? "attributes"
      puts "In attribues"
      doc.elements.each(matchString) do |i|
         string = i.attributes.to_s
         i = string.split("=")
         l = i[2].chop
         doc.elements.each("rdf:RDF/owl:Class") do |i|
            parentclass = i.attributes.to_s
            a = parentclass.split("=")
            z = a[2].chop
            if l.eql? z
              puts l
            end
         end
      end
   end
   return string
end


def subClassOf()
   subclass = xmlParseText("rdf:RDF/owl:Class/rdfs:subClassOf", "attributes")
end

def classParse()
   puts "\n CLASS:"
   parentClass = xmlParseText("rdf:RDF/owl:Class/rdfs:label", "Text")
   puts parentClass
end

def objPropParse()
   puts("\n OBJECT PROP:")
   objprop = xmlParseText("rdf:RDF/owl:ObjectProperty/rdfs:label","Text")
   puts objprop
end

#xmlParse()
classParse()
objPropParse()
subClassOf()
