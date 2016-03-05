require 'fileutils'
require 'tempfile'

module ConceptualBlending
  class HetsExtraction
    HETS_BINARY = ENV['HETS_BINARY'] || 'hets'

    attr_accessor :file, :nodes

    def initialize(file, nodes)
      self.file =
        if file.start_with?('file://')
          file.sub(%r(\Afile://), '')
        else
          file
        end
      self.nodes = nodes
    end

    def call
      result = {}
      Tempfile.create(['source', File.extname(file)]) do |source_tempfile|
        if file.include?('://')
          source_tempfile.write(%x(curl -s -H "Accept: text/plain" #{file}))
          source_tempfile.close
        else
          source_tempfile.close
          raise UserError, "file #{file} does not exist" unless File.exist?(file)
          FileUtils.cp(file, source_tempfile.path)
        end
        if nodes.any?
          output = %x(#{HETS_BINARY} -v -o th -n #{nodes.join(',')} "#{source_tempfile.path}")
          written_files = output.scan(/Writing file: (?<out_filepath>.*)$/).flatten
          written_files.each_with_index do |path, index|
            result[nodes[index]] = clean_from_casl_constructs(File.read(path))
          end
        else
          output = %x(#{HETS_BINARY} -v -o th "#{source_tempfile.path}")
          match = output.match(/Writing file: (?<out_filepath>.*)$/)
          result = clean_from_casl_constructs(File.read(match[:out_filepath]))
        end
      end
      result
    end

    protected

    def clean_from_casl_constructs(file_contents)
      file_contents.
        sub(/^\%prefix[^\n]+$/, '').
        sub(/^logic \S+$/, '').
        sub(/^spec\s\S+\s=$/, '').
        strip
    end
  end
end
