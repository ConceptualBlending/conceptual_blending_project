require 'rdf/rdfxml'

RDF::RDFXML::Reader.open("NewBird.owl") do |reader|
  reader.each_statement do |statement|
    puts statement.inspect
  end
end
