require 'json'

def medusa_consistency_check(markupURL, repoURL)

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
        occ = 0
        arr = []
        markup_hash['Relations'].each do |r|
           if ((r['Individual1'] == i) and (r['Point1'] == p[0])) or ((r['Individual2'] == i) and (r['Point2'] == p[0]))
             occ = occ + 1
             arr.push(r)
           end # if
        end # r
        if occ > 0 
         missingPairs[i] = arr
       end # p
    end  # if 
  end # x
 end # h

 return missingPairs

end
