require_relative 'completeness_check.rb'

class HetsMedusa
  HETS_BINARY = ENV['HETS_BINARY'] || 'hets'
  MEDUSA_ROOT = File.join(File.dirname(__FILE__), '../medusa/Medusa')
  MEDUSA_BINARY = ENV['MEDUSA_BINARY'] || File.join(MEDUSA_ROOT, 'Binaries/Release/medusa.exe')
  MEDUSA_REPOSITORY = ENV['MEDUSA_REPOSITORY'] || File.join(File.dirname(__FILE__), '../medusa_repository/Repository.json')

  attr_accessor :blend_temp_filepath, :png_target_filepath, :missing_pairs

  def initialize(blend_temp_filepath, png_target_filepath, node = nil)
    self.blend_temp_filepath = blend_temp_filepath
    self.png_target_filepath = png_target_filepath
    self.missing_pairs = []
    @node = node
  end

  def run
    medusa_markup_filepath = create_medusa_json(blend_temp_filepath)
    if complete?(medusa_markup_filepath)
      medusa_png_filepath = create_png_using_medusa(medusa_markup_filepath)

      true
    else
      puts 'Medusa markup is not complete. Please add axioms to complete it.'
      puts 'The following pairs are missing:'
      puts missing_pairs.inspect

      false
    end
  end

  protected

  def create_medusa_json(filepath)
    output = %x(#{HETS_BINARY} --full-signatures -a none -v2 +RTS -K1G -RTS --full-theories -A -n #{node} -o medusa.json -O "#{File.dirname(filepath)}" "#{filepath}")
    match = output.match(/Writing file: (?<out_filepath>.*)$/)
    if match
      match[:out_filepath]
    else
      raise "Hets could not process the file.\n"\
        "Its output is:\n#{output}"
    end
  end

  def create_png_using_medusa(medusa_markup_filepath)
    output = %x(mono "#{MEDUSA_BINARY}" --overwrite "#{MEDUSA_REPOSITORY}" "#{medusa_markup_filepath}" "#{png_target_filepath}")
    success = output.strip.empty?
    if !success
      raise "Medusa could not create the blend picture:\n"\
        "#{output}\n"\
        "The Medusa markup file was stored at #{medusa_markup_filepath}"
    end
  end

  def complete?(medusa_markup_filepath)
    self.missing_pairs = CompletenessCheck.
      run(medusa_markup_filepath, MEDUSA_REPOSITORY)

    missing_pairs.empty?
  end

  def node
    @node.nil? ? 'Blend' : @node
  end
end
