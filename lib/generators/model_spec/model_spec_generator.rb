require 'rails/generators/base'

class ModelSpecGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

	def copy_spec_file
		template "model_spec.rb", "spec/models/#{file_name.singularize.downcase}_spec.rb"
	end
end
