require_relative 'updaters/quality_updater_fallback'

class UpdatersFactory
  def updaters
    updater_instances << QualityUpdaterFallback.new
  end

  private

  def updater_instances
    Dir.glob('updaters/*_updater.rb').map do |file|
      require_relative file

      filename = file.split('/').last
      class_from_name(filename_to_class_name(filename)).new
    end
  end

  def filename_to_class_name(filename)
    filename.gsub('.rb', '').split('_').map(&:capitalize).join('')
  end

  def class_from_name(name)
    Object.const_get(name)
  end
end
