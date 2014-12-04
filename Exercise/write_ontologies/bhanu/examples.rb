#####################
#####################


#class: car subclassof: vehicle

c = Symbols.new(CLASS,"car")
v = Symbols.new(CLASS,"vehicle")
cc = AtomicConcept.new(c)
vc =  AtomicConcept.new(v)
s1 = ConceptSubsumption.new(cc,vc)

#####################
#####################

#Class: Truck subclassof: vehicle and has_part some Trailer

T = symbols.new(CLASS,"Truck")
Tr = Symbols.new(CLASS,"Trailer")
hap = Symbols.new(ROLE,"has_part")
Tc = AtomicConcept.new(T)
Trc = AtomicConcept.new(Tr)
Vc1 = AtomicConcept.new(V)
hapr = AtomicObjectProperty(hap)
c2 = ExistentialConcept.new(hapr,Tr)
c1 = AndConcept.new(Vc1,c2)
s2 = ConceptSubsumption.new(Tc,c1)


#####################
#####################

#class: Rugby Subclassof: Team Sport

R = Symbols.new(CLASS,"Rugby")
Te = Symbols.new(CLASS,"Team Sport")
Rc = AtomicConcept.new(R)
Tec = AtomicConcept.new(Te)
s3 = ConceptSubsumption.new(Rc,Tec)


#####################
#####################

#class: American_Football EquivalentTo: Rugby and  is_played_by only (Players and wears some Helmet)

P = Symbols.new(CLASS,"Players")
H = Symbols.new(CLASS,"Helmet")
A = Symbols.new(CLASS,"American_Football")
ip = Symbols.new(ROLE,"is_played")
wp = Symbols.new(ROLE,"wears")
Pc = AtomicConcept.new(P)
Hc = AtomicConcept.new(H)
Ac = AtomicConcept.new(A)
Rc1 = AtomicConcept.new(R)
ipr = AtomicObjectProperty(ip)
wpr = AtomicObjectProperty(wp)
c6 = ExistentialConcept.new(wpr,Hc)
c5 = AndConcept.new(Pc,c6)
c4 = ForallConcept.new(ipr,c5)
c3 = AndConcept.new(Rc1,C4)
s4 = ConceptEquivalence.new(Ac,c3)

#####################
#####################


#Class: hovercraft subclassof : vehicle and travels_on some (water or land)

Ho = Symbols.new(CLASS,"Hovercraft")
Wa = Symbols.new(CLASS,"Water")
L = Symbols.new(CLASS,"Land")
Top = Symbols.new(ROLE,"Travels_on")
Hoc = AtomicConcept.new(Ho)
Wac = AtomicConcept.new(wa)
Lc = AtomicConcept.new(L)
Vc1 = AtomicConcept.new(V)
Topr = AtomicObjectProperty(Top)
c7 = OrConcept.new(Wac,Lc)
c8 = ExistentialConcept.new(Topr,c7)
c9 = AndConcept.new(Vc1,c8)
s5 = ConceptSubsumption.new(Hoc,c9)

#####################
#####################

#Class: Liquid_Crystal_Display subclassOf: Monitors

Li = Symbols.new(CLASS,"Liquid_Crystal_Display")
M = Symbols.new(CLASS,"Monitors")
Lic = AtomicConcept.new(Li)
Mc = AtomicConcept.new(M)
s6 = ConceptSubsumption.new(Li,M)

#####################
#####################

#Class: Cathode_ray_Tube EquivalentTo: Monitors and has_product some Vacuum_tube

Ca = Symbols.new(CLASS,"Cathode_Ray_tube")
Va = Symbols.new(CLASS,"Vacuum_tube")
hp = Symbols.new(ROLE,"has_product")
Cac = AtomicConcept.new(Ca)
Vac = AtomicConcept.new(Va)
Mc1 = AtomicConcept.new(M)
hpr = AtomicObjectProperty(hp)
c10 = ExistentialConcept.new(hpr,Vac)
c11 = AndConept.new(Mc1,c10)
s7 = ConceptEquivalence.new(Cac,c11)

#####################
#####################

#class: Snake SubclassOf: Reptiles

S = Symbols.new(CLASS,"Snake")
Re = Symbols.new(CLASS,"Reptiles")
Sc = AtomicConcept.new(S)
Rec = AtomicConcept.new(Re)
S8 = ConceptSubsumption.new(Sc,Rec)

#####################
#####################

#Class: Turtle EquivalentTo: Reptiles and has_habitat some ( land and water)

Tu = Symbols.new(CLASS,"Turtles")
Hhp = Symbols.new(ROLE,"has_habitat")
Tuc = AtomicConcept.new(Tu)
Rec1 = AtomicConcept.new(Re)
Lc1 = AtomicConcept.new(L)
Wac1 = AtomicConcept.new(Wa)
Hhpr = AtomicObjectProperty.new(Hhp)
c12 = Orconcept.new(Wac1,Lc1)
c13 = ExistentialConcept.new(Hhpr,c12)
c14 = AndConcept.new(Rec1,c13)
s9 = ConceptEquivalence.new(Tuc,c14)

#####################
#####################


 #Class Frequency_Modulation EquivalentTo: Amplitude_Modulation
 
 Am = Symbols.new(CLASS,"Amplitude_Modulation")
 Fm = Symbols.new(CLASS,"Frequency_Modulation")
 Amc = AtomicConcept.new(Am)
 Fmc = AtomicConcept.new(Fm)
 s10 = ConceptEquivalence.new(Amc,Fmc)
 
 ####################
 ####################
