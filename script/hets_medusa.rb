class HetsMedusa
  MEDUSA_ROOT = File.join(File.dirname(__FILE__), '../medusa/Medusa')
  MEDUSA_BINARY = ENV['MEDUSA_BINARY'] || File.join(MEDUSA_ROOT, 'Binaries/Release/medusa.exe')
  MEDUSA_REPOSITORY = ENV['MEDUSA_REPOSITORY'] || File.join(MEDUSA_ROOT, 'Examples/Repository/Repository.json')

  attr_accessor :blend_temp_filepath, :png_target_filepath

  def initialize(blend_temp_filepath, png_target_filepath)
    self.blend_temp_filepath = blend_temp_filepath
    self.png_target_filepath = png_target_filepath
  end

  def run
    medusa_markup_filepath = create_medusa_json(blend_temp_filepath)
    medusa_png_filepath = create_png_using_medusa(medusa_markup_filepath)
  end

  protected

  def create_medusa_json(filepath)
    output = %x(hets --full-signatures -a none -v2 +RTS -K1G -RTS --full-theories -A -n Blend -o medusa.json -O "#{File.dirname(filepath)}" "#{filepath}")
    match = output.match(/Writing file: (?<out_filepath>.*)$/)
    match[:out_filepath]
  end

  def create_png_using_medusa(medusa_markup_filepath)
    %x(mono "#{MEDUSA_BINARY}" --overwrite "#{MEDUSA_REPOSITORY}" "#{medusa_markup_filepath}" "#{png_target_filepath}")
  end
end
