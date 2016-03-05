require 'fileutils'
require 'nokogiri'
require 'tempfile'

module ConceptualBlending
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
          'Inconsistency' => axioms(doc, 'Inconsistency'),
        }
      end
      annotate_axioms_with_their_origin(axioms)
      axioms
    end

    protected

    def on_analysis_result
      command = nil
      Tempfile.create(['result', '.xml']) do |tempfile|
        tempfile.close
        command = %(#{HETS_BINARY} -o xml --full-signatures -a none -v +RTS -K1G -RTS --full-theories -A -O "#{File.dirname(tempfile.path)}" "#{original_file_url}")
        output = %x(#{command})
        match = output.match(/Writing file: (?<out_filepath>.*)$/)
        if match
          FileUtils.mv(match[:out_filepath], tempfile.path)
          yield(tempfile.path)
        else
          raise "Hets could not process the file.\n"\
            "Its output is:\n#{output}"
        end
      end
    rescue
      $stderr.puts "Tried and failed to call:\n#{command}"
      raise
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
end
