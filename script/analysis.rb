require 'fileutils'
require 'nokogiri'
require 'tempfile'

class Analysis
  HETS_BINARY = ENV['HETS_BINARY'] || 'hets'

  attr_accessor :original_file_url

  def initialize(original_file_url)
    self.original_file_url = original_file_url
  end

  def run
    axioms = nil
    on_analysis_result do |filepath|
      doc = File.open(filepath) { |f| Nokogiri::XML(f) }
      axioms = {
        'InputSpace1' => axioms(doc, 'InputSpace1'),
        'InputSpace2' => axioms(doc, 'InputSpace2'),
        'Base' => axioms(doc, 'Base'),
        'Blend' => axioms(doc, 'Blend'),
      }
    end
    annotate_axioms_with_their_origin(axioms)
    axioms
  end

  protected

  def on_analysis_result
    Tempfile.create(['result', '.xml']) do |tempfile|
      output = %x(#{HETS_BINARY} -o xml --full-signatures -a none -v +RTS -K1G -RTS --full-theories -A -O #{File.dirname(tempfile.path)} #{original_file_url})
      match = output.match(/Writing file: (?<out_filepath>.*)$/)
      tempfile.close
      FileUtils.mv(match[:out_filepath], tempfile.path)
      yield(tempfile.path)
    end
  end

  def axioms(doc, node)
    doc_axioms = doc.search("DGNode[name=#{node}]").first.xpath('*/Axiom')
    result = []
    doc_axioms.each do |doc_axiom|
      result << {name: doc_axiom.attributes['name'].value,
                 text: doc_axiom.search('Text').first.children.first.to_s}
    end
    result
  end

  def annotate_axioms_with_their_origin(axioms)
    axioms['Blend'].map! do |blend_axiom|
      input_space1_intersection =
        axioms['InputSpace1'].select { |a| a[:text] == blend_axiom[:text] }
      input_space2_intersection =
        axioms['InputSpace2'].select { |a| a[:text] == blend_axiom[:text] }
      originals = {}
      if input_space1_intersection.any?
        originals['InputSpace1'] = input_space1_intersection
      end
      if input_space2_intersection.any?
        originals['InputSpace2'] = input_space2_intersection
      end
      blend_axiom[:originals] = originals if originals.any?
      blend_axiom
    end
  end
end
