require 'json'

module ConceptualBlending
  class CompletenessCheck
    def self.call(markupURL, repoURL)

      markup = File.read(markupURL)
      repo = File.read(repoURL)
      markup_hash = JSON.parse(markup)
      repo_hash = JSON.parse(repo)

      missingPairs = Hash.new

      markup_hash['Definitions'].each do |h|
        i = h['Identifier']
        t = h['Type']
        repo_hash['RepositoryContent'].each do |x|
          if x['Type'] == t
            x['Points'].each do |p|
              unless markup_hash['Relations'].any? do |r|
                ((r['Individual1'] == i) and (r['Point1'] == p[0])) or ((r['Individual2'] == i) and (r['Point2'] == p[0]))
              end # r
              missingPairs[i] = p[0]
              end # if
            end # p
          end  # if
        end # x
      end # h

      return missingPairs
    end
  end
end
