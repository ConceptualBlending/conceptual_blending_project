load 'pp.rb'
$top = Symbols.new(CLASS,"Thing")

# Class: Quadrilaterals  EquivalentTo: Squares and Rectangles

q = Symbols.new(CLASS, "Quadrilaterals")
s = Symbols.new(CLASS, "Squares")
r=  Symbols.new(CLASS, "Rectangles")
qc = AtomicConcept.new(q)
sc = AtomicConcept.new(s)
rc = AtomicConcept.new(r)
c1=AndConcept.new(sc,rc)

# Class: Quadrilaterals  EquivalentTo: Rhombus and Rectangles

rh=  Symbols.new(CLASS, "Rhombus")
rhc = AtomicConcept.new(rh)
c2= AndConcept.new(rhc,rc)

# Class: Car SubclassOf: has_modelnr some Model

c = Symbols.new(CLASS, "Car")
m = Symbols.new(CLASS, "Model")
hm=Symbols.new(ROLE,"has_modelnr")
cc=AtomicConcept.new(c)
mc=AtomicConcept.new(m)
hmr = AtomicObjectProperty.new(hm)
c3 = ExistentialConcept.new(hmr,mc)
s1 = ConceptEquivalence.new(cc,c3)

# Class: Car SubclassOf: has_color some Model

hc=Symbols.new(ROLE,"has_color")
hcr = AtomicObjectProperty.new(hc)
c4 = ExistentialConcept.new(hcr,mc)
s2 = ConceptEquivalence.new(cc,c4)

# Method for Antiunification

  def antiunify(concept1,concept2)

    if concept1.is_a?(AndConcept)
      if concept2.is_a?(AndConcept)
        andresult = AndConcept.new(antiunify(concept1.components[0],concept2.components[0]),antiunify(concept1.components[1],concept2.components[1]))
        return andresult
      end
    end
    if concept1.is_a?(AtomicConcept)
      if concept2.is_a?(AtomicConcept)
      res=antiunify(concept1.name,concept2.name)
      s=Symbols.new(CLASS,res)
      return AtomicConcept.new(s)
      end
    end

    if concept1.is_a?(Symbols)  && concept2.is_a?(Symbols)
      c1=concept1.name
      c2=concept2.name
      if c1==c2
        return c1
      else
        return "X"
      end
    end
    if concept1.is_a?(ExistentialConcept)
      if concept2.is_a?(ExistentialConcept)
        existresult = ExistentialConcept.new(antiunify(concept1.components[0],concept2.components[0]),antiunify(concept1.components[1],concept2.components[1]))
        return existresult
      end
    end

    if concept1.is_a?(AtomicObjectProperty) && concept2.is_a?(AtomicObjectProperty)
      result=antiunify(concept1.name,concept2.name)
      ac= AtomicObjectProperty.new(result)
      return ac
    end


    if (concept1.is_a?(AtomicConcept)&&(concept2.is_a?(AndConcept) || concept2.is_a?(ExistentialConcept)))||(concept1.is_a?(ExistentialConcept)&&(concept2.is_a?(AndConcept) || concept2.is_a?(AtomicConcept)))||(concept1.is_a?(AndConcept)&&(concept2.is_a?(AtomicConcept) || concept2.is_a?(ExistentialConcept)))
      s=Symbols.new(CLASS,"X")
      return AtomicConcept.new(s)
    end


    if concept1==$top || concept2==$top
      return $top
    end
  end

concept1= [c1,$top]
concept2= [c2]
result =Array.new(200)
concept1.each do |concept1|
  concept2.each do |concept2|
  antiunify(concept1,concept2).show
  puts "\n"
  end
end
