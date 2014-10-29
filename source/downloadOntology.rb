
# Due to the error of parsing by hets, this method is developed to download the ontology and store them in a file and later be read during makeInputFile.rb execution where the contents of the files
# will be written in the inputForBlend.dol file.

require 'open-uri'


def download_Ontology(owl_file, url)

open(owl_file, 'w') do |file|
  file << open(url).read
end

return

end



#download_Ontology('tiger.owl', "https://ontohub.org/monster-blend/animals/tiger.owl")
