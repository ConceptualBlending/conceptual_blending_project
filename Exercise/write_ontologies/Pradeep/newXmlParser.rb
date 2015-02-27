require 'set'
require 'rdf/rdfxml'

require 'rexml/document'
include REXML
#load '../../../source/data.rb'
#load '../bhanu/pp.rb'

Type = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
Classtype = "http://www.w3.org/2002/07/owl#Class"
ObjProptype = "http://www.w3.org/2002/07/owl#ObjectProperty"
SubClasstype = "http://www.w3.org/2000/01/rdf-schema#subClassOf"
Firsttype = "http://www.w3.org/1999/02/22-rdf-syntax-ns#first"
Resttype = "http://www.w3.org/1999/02/22-rdf-syntax-ns#rest"
OnPropertytype = "http://www.w3.org/2002/07/owl#onProperty"
QualifiedContType = "http://www.w3.org/2002/07/owl#qualifiedCardinality" 
Mintype = "http://www.w3.org/2002/07/owl#minQualifiedCardinality"
SomeValuesFromtype = "http://www.w3.org/2002/07/owl#someValuesFrom"
Maxtype = "http://www.w3.org/2002/07/owl#maxQualifiedCardinality"
OnClass = "http://www.w3.org/2002/07/owl#onClass"
IntersectionOftype = "http://www.w3.org/2002/07/owl#intersectionOf"
Nilltype = "http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"
Restrictiontype = "http://www.w3.org/2002/07/owl#Restriction"

################################################################
# Name : parseSymbols
# 
# Attributes : REXML file
# 
# Action : Parse the file from top to bottom.
#
###############################################################
def parseSymbols(file)
   cSet = Set[]
   dSet = Set[]
   dSet1 = Set[]
   iSet1 = Set[]
   string = Array.new()
   sens = []
   acSubClass = []
   subClass = []
   symSubClass = []
   exactConcept = []
   symPrntClass = []
   acSubClass = []
   acClass = []
   acpropString = []
   ac = []
   acocElement = []
   sens = []
   i = 0
   j = 0
   value = 0
   res = 0
   min = 0
   max = 0
   qc = 0
   maxobj = 0
   minobj = 0
   qcobj = 0
   
   subj = Array.new()
   pred = Array.new()
   obj = Array.new() 
   RDF::RDFXML::Reader.open(file) do |reader|
      reader.each_triple do |subject, predicate, object|
         subj[i] = subject
         pred[i] = predicate
         obj[i] = object
         i += 1
      end
   end
   begin   
      value = checkPredicateString(pred[j])

      if (value == 1)
         string = pred[j]
      else
         string = obj[j]
      end
      case string 
      
      when Classtype 
          # puts "Class"  
           symClass = Symbols.new(CLASS, subj[j])
           acClass = AtomicConcept.new(symClass)
           cSet.add(symClass)

      when ObjProptype  
           #puts "Obj"
           symObjProp = Symbols.new(ROLE, subj[j])
           acObjProp = AtomicConcept.new(symObjProp)
           dSet.add(symObjProp)

      when SubClasstype
           if obj[j].to_s.include? "_:g"
              if qc == 1
                 exactConcept = ExactConcept.new(acpropString, qcobj, acocElement)
                 subClass = exactConcept
                 qc = 0

              elsif min == 1
                 minConcept = MinConcept.new(acpropString, minobj , acocElement) 
                 subClass = minConcept
                 min = 0
              elsif max == 1
                  maxConcept = MaxConcept.new(acpropString, maxobj , acocElement)
                  subClass = maxConcept
                  max = 0
              end   
              symPrntClass = Symbols.new(CLASS, subj[j])  
           else 
              symSubClass = Symbols.new(CLASS, subj[j])
              subClass = AtomicConcept.new(symSubClass)
              symPrntClass = Symbols.new(CLASS, obj[j])
           end
           #symPrntClass = Symbols.new(CLASS, subj[j])
           acPrntClass = AtomicConcept.new(symPrntClass)
           cs1 =  ConceptSubsumption.new(acPrntClass, subClass) #acPrntClass)
           sens.push(cs1)

      when OnPropertytype
           #puts "OnPropertytype"
           propString = Symbols.new(ROLE, obj[j])
           acpropString = AtomicObjectProperty.new(propString)
          # nodeElement.push(acpropString)
      when QualifiedContType
           qcobj  = obj[j]
           qc = 1

      when Mintype
           min = 1
           minobj = obj[j]

      when Maxtype
           max = 1
           maxobj = obj[j]

      when OnClass
           symocElement = Symbols.new(CLASS,obj[j])
           acocElement = AtomicConcept.new(symocElement)

      when Restrictiontype   
           res = 0            
      else 
           #puts "Element not found"
      end
      j = j + 1
   end until (subj.length == j)
   iSet1 = Set[]
   sig = Signature.new(cSet, dSet, dSet1, iSet1)
   onto1 = Ontology.new(sig, sens)
   #p onto1
   return onto1

end


def checkPredicateString(string)
   if type(string) == 1
      return 1 
   else 
     return 0
   end
end


def type(string)
   case string 
   when Type 
      return 0
   when Classtype
      return 1
   when SubClasstype
      return 1
   when Firsttype
      return 1
   when Resttype
      return 1
   when OnPropertytype
      return 1
   when SomeValuesFromtype
      return 1
   when IntersectionOftype
      return 1
   when Nilltype
      return 1
   when QualifiedContType
      return 1
   when Maxtype
      return 1
   when Mintype
      return 1
   when OnClass
      return 1
   
   else
      return 0
   end
end



#parseSymbols("/home/pradeep/FunProg/RubyFun/OVGU_Prjct/conceptual_blending_project/Exercise/write_ontologies/Pradeep/b.owl")#and & some.owl")


