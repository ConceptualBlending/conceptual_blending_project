load "pp.rb"
require 'json'

####################################### Render Method ############################################

# Method to generate the input file in the format of JSON for Monster Rendering System

def Render(ontology)

# Extracting object Property "meets" from Ontology to find the meet-pairs
  ontology.o_signature.objProps.each do  |n|
    if(n.name=="meets")
      $op2=AtomicObjectProperty.new(n)
    end
  end

# Initializing meet-pairs in the given ontology
  $meetpairs = Array.new

# Initializing pairs other than meet-pairs in the given ontology
  $otherpairs= Array.new

# Initialized for finding the sentence patterns that match meet-pairs
  $patterns  = Array.new

# Initialized to find the patterns used to derive Definitions
  $Definitionpatterns  = Array.new

  $i=0

# Finding meet-pairs from all the sentences in Ontology
while $i<ontology.o_sentences.length do
  if ontology.o_sentences[$i].is_a?(FactAssertion)&&ontology.o_sentences[$i].components[1].name.name==$op2.name.name
    $meetpairs.push(ontology.o_sentences[$i])
  else
    $otherpairs.push(ontology.o_sentences[$i])
  end
  $i +=1
end

# Finding pairs other than meet-pairs
for i in $meetpairs.length.times do
  for j in 0..2 do
    if j!=1 then
      for k in $otherpairs.length.times do
        if $meetpairs[i].components[j]==$otherpairs[k].components[0]||$meetpairs[i].components[j]==$otherpairs[k].components[2]
          $patterns.push($otherpairs[k])
        end
      end
    end
  end
end

# Finding Definition Patterns
for i in $patterns.length.times do
  if $patterns[i].is_a?(FactAssertion)
    for k in $otherpairs.length.times do
      if ($patterns[i].components[0]==$otherpairs[k].components[0])&&($otherpairs[k].is_a?(TypeAssertion))
        $Definitionpatterns.push($otherpairs[k])
      end
    end
  end
end

# Method to find the Relation Patterns
  def findRelations(point)

    for i in $patterns.length.times do
      if (point==$patterns[i].components[0].name)
        for j in $patterns.length.times do
          if($patterns[i].components[2].name==$patterns[j].components[0].name)
            return $patterns[j].components[1].name.name
          end
        end
      end
    end
  end

# Creating Markup File for Monster Rendering System
File.open("_markup.json","w") do |f|

  # Loading Definitions into Markup File
  f.write("{\n")
  f.write("  \"Definitions\": [\n")
  definitionpatterns=Array.new
  definitionpatterns=$Definitionpatterns.dup.uniq
  for i in definitionpatterns.length.times do
    f.puts "   {"
    f.puts "     \"Identifier\": "+ "\""+ "#{definitionpatterns[i].components[0].name}"+ "\""+","
    f.puts "     \"Type\": "+ "\""+ "#{definitionpatterns[i].components[1].name.name}"+ "\""
    if i==definitionpatterns.length-1
      f.print "   }"
    else
      f.puts "   },"
    end
  end
  f.write("\n  ],")

  # Loading Relations into Markup File
  f.write("\n  \"Relations\": [\n")
  for i in ($Definitionpatterns.length-1).times do
    f.puts "   {"
    f.puts "     \"Individual1\": "+ "\""+ "#{$Definitionpatterns[i].components[0].name}"+ "\""+","
    $point1=findRelations("#{$Definitionpatterns[i].components[0].name}") # Finding Relation using FindRelations Method

    f.puts "     \"Point1\": "+ "\""+ "#{$point1}"+ "\""+","

    f.puts "     \"Individual2\": "+ "\""+ "#{$Definitionpatterns[i+1].components[0].name}"+ "\""+","
    $point2=findRelations("#{$Definitionpatterns[i+1].components[0].name}") #Finding Relation using FindRelations Method

    f.puts "     \"Point2\": "+ "\""+ "#{$point2}"+ "\""

    if i==$Definitionpatterns.length-2
      f.print "   }"
    else
      f.puts "   },"
    end
  end
  f.write("\n  ]\n")
  f.write("}")
end
end

####################################### End Of Render Method ############################################

# Sample code of Lion Ontology

# ObjectProperty: part_of

p = Symbols.new(ROLE, "part_of")
op1=AtomicObjectProperty.new(p)

# ObjectProperty: has_fiat_boundary

hfb = Symbols.new(ROLE, "has_fiat_boundary")
op2=AtomicObjectProperty.new(hfb)

# ObjectProperty: meets

meets = Symbols.new(ROLE, "meets")
op3=AtomicObjectProperty.new(meets)

# Class: FiatBoundary

fb = Symbols.new(CLASS, "FiatBoundary")
fbc = AtomicConcept.new(fb)

# Class: NeckBoundary
#	SubClassOf: FiatBoundary

nb = Symbols.new(CLASS, "NeckBoundary")
nbc = AtomicConcept.new(nb)

s25= ConceptSubsumption.new(nbc,fbc)


# Class: LeftForeLimbBoundary
#	SubClassOf: FiatBoundary

lflb = Symbols.new(CLASS, "LeftForeLimbBoundary")
lflbc = AtomicConcept.new(lflb)

s26= ConceptSubsumption.new(lflbc,fbc)

# Class: RightForeLimbBoundary
#	SubClassOf: FiatBoundary

rflb = Symbols.new(CLASS, "RightForeLimbBoundary")
rflbc = AtomicConcept.new(rflb)

s27= ConceptSubsumption.new(rflbc,fbc)

# Class: LeftHindLimbBoundary
#	SubClassOf: FiatBoundary

lhlb = Symbols.new(CLASS, "LeftHindLimbBoundary")
lhlbc = AtomicConcept.new(lhlb)

s28= ConceptSubsumption.new(lhlbc,fbc)

# Class: RightHindLimbBoundary
#	SubClassOf: FiatBoundary

rhlb = Symbols.new(CLASS, "RightHindLimbBoundary")
rhlbc = AtomicConcept.new(rhlb)

s29= ConceptSubsumption.new(rhlbc,fbc)

# Class: TailBoundary
#	SubClassOf: FiatBoundary

tb = Symbols.new(CLASS, "TailBoundary")
tbc = AtomicConcept.new(tb)

s30= ConceptSubsumption.new(tbc,fbc)

# Class: ProximalBoundary
#	SubClassOf: FiatBoundary

pb = Symbols.new(CLASS, "ProximalBoundary")
pbc = AtomicConcept.new(pb)

s31= ConceptSubsumption.new(pbc,fbc)

# Class: DistalBoundary
#	SubClassOf: FiatBoundary

db = Symbols.new(CLASS, "DistalBoundary")
dbc = AtomicConcept.new(db)

s32= ConceptSubsumption.new(dbc,fbc)

l = Symbols.new(CLASS, "Limb")
lc = AtomicConcept.new(l)

le = Symbols.new(CLASS, "LimbEnd")
lec = AtomicConcept.new(le)

# Class: Arm
#	SubClassOf: Limb

a = Symbols.new(CLASS, "Arm")
ac = AtomicConcept.new(a)

s33= ConceptSubsumption.new(ac,lc)

# Class: Leg
#	SubClassOf: Limb

lg = Symbols.new(CLASS, "Leg")
lgc = AtomicConcept.new(lg)

s34= ConceptSubsumption.new(lgc,lc)

# Class: Claw
#	SubClassOf: LimbEnd

clw = Symbols.new(CLASS, "Claw")
clwc = AtomicConcept.new(clw)

s35= ConceptSubsumption.new(clwc,lec)

# Class: Paw
#	SubClassOf: LimbEnd

pw = Symbols.new(CLASS, "Paw")
pwc = AtomicConcept.new(pw)

s36= ConceptSubsumption.new(pwc,lec)

# Class: Foot
#	SubClassOf: LimbEnd

ft = Symbols.new(CLASS, "Foot")
ftc = AtomicConcept.new(ft)

s37= ConceptSubsumption.new(ftc,lec)

# Class: Organism

o = Symbols.new(CLASS, "Organism")
oc = AtomicConcept.new(o)

# Class: Carnivore
#	SubClassOf: Organism

c = Symbols.new(CLASS, "Carnivore")
cc = AtomicConcept.new(c)

s1=ConceptSubsumption.new(cc,oc)

# Class: BodyPart
#	SubClassOf: part_of some Organism

bp = Symbols.new(CLASS, "BodyPart")
bpc = AtomicConcept.new(bp)

c1 = ExistentialConcept.new(op1,oc)

s2=ConceptSubsumption.new(bpc,c1)

# Class: Hair
#	SubClassOf: BodyPart

hr = Symbols.new(CLASS, "Hair")
hrc = AtomicConcept.new(hr)

s3= ConceptSubsumption.new(hrc,bpc)

# Class: CardinalBodyPart
#	SubClassOf: BodyPart

cbp = Symbols.new(CLASS, "CardinalBodyPart")
cbpc = AtomicConcept.new(cbp)

s4= ConceptSubsumption.new(cbpc,bpc)

# Class: Head
#	SubClassOf: CardinalBodyPart
#	SubClassOf: has_fiat_boundary exactly 1 FiatBoundary

h = Symbols.new(CLASS, "Head")
hc = AtomicConcept.new(h)

s5= ConceptSubsumption.new(hc,cbpc)

c2= ExactConcept.new(op2,1,fbc)

s6= ConceptSubsumption.new(hc,c2)

# Class: Mane
#	SubClassOf: CardinalBodyPart
#	SubClassOf: has_fiat_boundary exactly 1 FiatBoundary


m = Symbols.new(CLASS, "Mane")
mc = AtomicConcept.new(m)

s7= ConceptSubsumption.new(mc,cbpc)
s8= ConceptSubsumption.new(mc,c2)

# Class: Trunk
#	SubClassOf: CardinalBodyPart

t = Symbols.new(CLASS, "Trunk")
tc = AtomicConcept.new(t)

s9= ConceptSubsumption.new(tc,cbpc)

# Class: Limb
#	SubClassOf: CardinalBodyPart
#	SubClassOf: has_fiat_boundary exactly 2 FiatBoundary
#	SubClassOf: has_fiat_boundary exactly 1 ProximalBoundary
#	SubClassOf: has_fiat_boundary exactly 1 DistalBoundary

s10= ConceptSubsumption.new(lc,cbpc)

c3= ExactConcept.new(op2,2,fbc)
s11= ConceptSubsumption.new(lc,c3)

c4= ExactConcept.new(op2,1,pbc)
s12= ConceptSubsumption.new(lc,c4)

c5= ExactConcept.new(op2,1,dbc)
s13= ConceptSubsumption.new(lc,c5)

# Class: Tail
#	SubClassOf: CardinalBodyPart
#	SubClassOf: has_fiat_boundary exactly 1 FiatBoundary

tl = Symbols.new(CLASS, "Tail")
tlc = AtomicConcept.new(tl)

s14= ConceptSubsumption.new(tlc,cbpc)
s15= ConceptSubsumption.new(tlc,c2)

# Class: LimbEnd
#	SubClassOf: CardinalBodyPart
#	SubClassOf: has_fiat_boundary exactly 1 FiatBoundary

s16= ConceptSubsumption.new(lec,cbpc)
s17= ConceptSubsumption.new(lec,c2)

# Class: QuadrupedTrunk
#	SubClassOf: has_fiat_boundary exactly 6 FiatBoundary
#	SubClassOf: has_fiat_boundary exactly 1 NeckBoundary
#	SubClassOf: has_fiat_boundary exactly 1 LeftForeLimbBoundary
#	SubClassOf: has_fiat_boundary exactly 1 RightForeLimbBoundary
#	SubClassOf: has_fiat_boundary exactly 1 LeftHindLimbBoundary
#	SubClassOf: has_fiat_boundary exactly 1 RightHindLimbBoundary
#	SubClassOf: has_fiat_boundary exactly 1 TailBoundary

qt = Symbols.new(CLASS, "QuadrupedTrunk")
qtc = AtomicConcept.new(qt)

c6= ExactConcept.new(op2,6,fbc)
c7= ExactConcept.new(op2,1,nbc)
c8= ExactConcept.new(op2,1,lflbc)
c9= ExactConcept.new(op2,1,rflbc)
c10= ExactConcept.new(op2,1,lhlbc)
c11= ExactConcept.new(op2,1,rhlbc)
c12= ExactConcept.new(op2,1,tbc)

s18= ConceptSubsumption.new(qtc,c6)
s19= ConceptSubsumption.new(qtc,c7)
s20= ConceptSubsumption.new(qtc,c8)
s21= ConceptSubsumption.new(qtc,c9)
s22= ConceptSubsumption.new(qtc,c10)
s23= ConceptSubsumption.new(qtc,c11)
s24= ConceptSubsumption.new(qtc,c12)

# Class: Lion
#	SubClassOf: Carnivore

lion = Symbols.new(CLASS, "Lion")
lionc = AtomicConcept.new(lion)

s38= ConceptSubsumption.new(lionc,cc)

# Class: LionTrunk
#	EquivalentTo: QuadrupedTrunk  and part_of some Lion

liont = Symbols.new(CLASS, "LionTrunk")
liontc = AtomicConcept.new(liont)

c13= ExistentialConcept.new(op1,lionc)
c14= AndConcept.new(qtc,c13)

s39= ConceptSubsumption.new(liontc,c14)


# Class: LionHead
#	EquivalentTo: Head and part_of some Lion

lionh = Symbols.new(CLASS, "LionHead")
lionhc = AtomicConcept.new(lionh)

c15= AndConcept.new(hc,c13)

s40= ConceptSubsumption.new(lionhc,c15)

# Class: LionMane
#	EquivalentTo: Mane and part_of some Lion

lionm = Symbols.new(CLASS, "LionMane")
lionmc = AtomicConcept.new(lionm)

c16= AndConcept.new(mc,c13)

s41= ConceptSubsumption.new(lionmc,c16)

# Class: LionLeg
#	EquivalentTo: Leg and part_of some Lion

lionlg = Symbols.new(CLASS, "LionLeg")
lionlgc = AtomicConcept.new(lionlg)

c17= AndConcept.new(lgc,c13)

s42= ConceptSubsumption.new(lionlgc,c17)

# Class: LionClaw
#	EquivalentTo: Claw and part_of some Lion

lionclw = Symbols.new(CLASS, "LionClaw")
lionclwc = AtomicConcept.new(lionclw)

c18= AndConcept.new(clwc,c13)

s43= ConceptSubsumption.new(lionclwc,c18)

# Class: LionTail
#	EquivalentTo: Tail and part_of some Lion

liontl = Symbols.new(CLASS, "LionTail")
liontlc = AtomicConcept.new(liontl)

c19= AndConcept.new(tlc,c13)

s44= ConceptSubsumption.new(liontlc,c19)

# Individual: thisLion
#    Types: Lion

tlion=Symbols.new(INDIVIDUAL,"thisLion")
s45=TypeAssertion.new(tlion,lionc)

# Individual: t-nb
#	Types: NeckBoundary

intnb=Symbols.new(INDIVIDUAL,"t-nb")
s46=TypeAssertion.new(intnb,nbc)

# Individual: t-lflb
#	Types: LeftForeLimbBoundary

intlflb=Symbols.new(INDIVIDUAL,"t-lflb")
s47=TypeAssertion.new(intlflb,lflbc)

# Individual: t-rflb
#	Types: RightForeLimbBoundary

intrflb=Symbols.new(INDIVIDUAL,"t-rflb")
s48=TypeAssertion.new(intrflb,rflbc)

# Individual: t-lhlb
#	Types: LeftHindLimbBoundary

intlhlb=Symbols.new(INDIVIDUAL,"t-lhlb")
s49=TypeAssertion.new(intlhlb,lhlbc)

# Individual: t-rhlb
#	Types: RightHindLimbBoundary

intrhlb=Symbols.new(INDIVIDUAL,"t-rhlb")
s50=TypeAssertion.new(intrhlb,rhlbc)

# Individual: t-tb
#	Types: TailBoundary

inttb=Symbols.new(INDIVIDUAL,"t-tb")
s51=TypeAssertion.new(inttb,tbc)

# Individual: t
#	 Types: LionTrunk
#	 Facts: part_of thisLion,
#	 	 	has_fiat_boundary t-nb,
#			has_fiat_boundary t-lflb,
#			has_fiat_boundary t-rflb,
#			has_fiat_boundary t-lhlb,
#			has_fiat_boundary t-rhlb,
#			has_fiat_boundary t-tb

int=Symbols.new(INDIVIDUAL,"t")
s52=TypeAssertion.new(int,liontc)

s53=FactAssertion.new(int,op1,tlion)
s54=FactAssertion.new(int,op2,intnb)
s55=FactAssertion.new(int,op2,intlflb)
s56=FactAssertion.new(int,op2,intrflb)
s57=FactAssertion.new(int,op2,intlhlb)
s58=FactAssertion.new(int,op2,intrhlb)
s59=FactAssertion.new(int,op2,inttb)



# Individual: h-nb
#	Types: ProximalBoundary
#	Facts: meets t-nb

inhnb=Symbols.new(INDIVIDUAL,"h-nb")
s60=TypeAssertion.new(inhnb,pbc)
s61=FactAssertion.new(inhnb,op3,intnb)

# Individual: h
#	Types: LionHead
#	Facts: part_of thisLion,
#			has_fiat_boundary h-nb

inh=Symbols.new(INDIVIDUAL,"h")
s62=TypeAssertion.new(inh,lionhc)
s63=FactAssertion.new(inh,op1,tlion)
s64=FactAssertion.new(inh,op2,inhnb)


# Individual: m
#	Types: LionMane
#	Facts: part_of thisLion,
#			has_fiat_boundary m-hb

# Individual: m-hb
#	Types: ProximalBoundary
#	Facts: meets h-nb

inmhb=Symbols.new(INDIVIDUAL,"m-hb")
s65=TypeAssertion.new(inmhb,pbc)
s66=FactAssertion.new(inmhb,op3,inhnb)

inm=Symbols.new(INDIVIDUAL,"m")
s67=TypeAssertion.new(inm,lionmc)
s68=FactAssertion.new(inm,op1,tlion)
s69=FactAssertion.new(inm,op2,inmhb)

# Individual: lfl
#	Types: LionLeg
#	Facts: part_of thisLion,
#	 		has_fiat_boundary lfl-pb,
#			has_fiat_boundary lfl-db

# Individual: lfl-pb
#	Types: ProximalBoundary
#	Facts: meets t-lflb

# Individual: lfl-db
#	Types: DistalBoundary

inlflpb=Symbols.new(INDIVIDUAL,"lfl-pb")
s70=TypeAssertion.new(inlflpb,pbc)
s71=FactAssertion.new(inlflpb,op3,intlflb)

inlfldb=Symbols.new(INDIVIDUAL,"lfl-db")
s72= TypeAssertion.new(inlfldb,dbc)

inlfl=Symbols.new(INDIVIDUAL,"lfl")
s73=TypeAssertion.new(inlfl,lionlgc)
s74=FactAssertion.new(inlfl,op1,tlion)
s75=FactAssertion.new(inlfl,op2,inlflpb)
s76=FactAssertion.new(inlfl,op2,inlfldb)

# Individual: lfh
#	Types: LionClaw
#	Facts: part_of thisLion,
#	 		has_fiat_boundary lfh-pb

# Individual: lfh-pb
#	Types: ProximalBoundary
#	Facts: meets lfl-db

inlfhpb=Symbols.new(INDIVIDUAL,"lfh-pb")
s77=TypeAssertion.new(inlfhpb,pbc)
s78=FactAssertion.new(inlfhpb,op3,inlfldb)

inlfh=Symbols.new(INDIVIDUAL,"lfh")
s79=TypeAssertion.new(inlfh,lionclwc)
s80=FactAssertion.new(inlfh,op1,tlion)
s81=FactAssertion.new(inlfh,op2,inlfhpb)

# Individual: lt
# Types: LionTail
# Facts: part_of thisLion,
#               has_fiat_boundary lt-tb

# Individual: lt-tb
# Types: ProximalBoundary
# Facts: meets t-tb

inlttb=Symbols.new(INDIVIDUAL,"lt-tb")
s82=TypeAssertion.new(inlttb,pbc)
s83=FactAssertion.new(inlttb,op3,inttb)

inlt=Symbols.new(INDIVIDUAL,"lt")
s84=TypeAssertion.new(inlt,liontlc)
s85=FactAssertion.new(inlt,op1,tlion)
s86=FactAssertion.new(inlt,op2,inlttb)

cSet = Set[fb,o,c,bp,hr,cbp,h,m,t,l,tl,le,qt,nb,lflb,rflb,lhlb,rhlb,tb,pb,db,a,lg,clw,pw,ft,lion,liont,lionh,lionm,lionlg,lionclw,liontl]
oSet = Set[p,hfb,meets]
dSet = Set[]
iSet = Set[tlion,intnb,intlflb,intrflb,intlhlb,intrhlb,inttb,int,inhnb,inh,inm,inmhb,inlfl,inlflpb,inlfldb,inlfh,inlfhpb,inlt,inlttb]

sigma = Signature.new(cSet,oSet,dSet,iSet)
ontology = Ontology.new(sigma, [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,s31,s32,s33,s34,s35,s36,s37,s38,s39,s40,s41,s42,s43,s44,s45,s46,s47,s48,s49,s50,s51,s52,s53,s54,s55,s56,s57,s58,s59,s60,s61,s62,s63,s64,s65,s66,s67,s68,s69,s70,s71,s72,s73,s74,s75,s76,s77,s78,s79,s80,s81,s82,s83,s84,s85,s86])

# A Call to Render method to generate the markup file with the Sample Ontology assumed
Render(ontology)
