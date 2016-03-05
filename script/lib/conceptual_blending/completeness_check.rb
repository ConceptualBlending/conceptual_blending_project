require 'json'

module ConceptualBlending
  class CompletenessCheck
    attr_accessor :markup_url, :repository_url

    def initialize(markup_url, repository_url)
      self.markup_url = markup_url
      self.repository_url = repository_url
    end

    def call
      markup = File.read(markup_url)
      repository = File.read(repository_url)

      markup_hash = JSON.parse(markup)
      repo_hash = JSON.parse(repository)

      missing_pairs = {}

      markup_hash['Definitions'].each do |h|
        identifier = h['Identifier']
        type = h['Type']
        repo_hash['RepositoryContent'].each do |x|
          if x['Type'] == type
            x['Points'].each do |p|
              unless markup_hash['Relations'].any? do |r|
                (r['Individual1'] == identifier && r['Point1'] == p[0]) ||
                  (r['Individual2'] == identifier && r['Point2'] == p[0])
              end # r
              missing_pairs[identifier] = p[0]
              end # if
            end # p
          end  # if
        end # x
      end # h

      return missing_pairs
    end
  end
end
