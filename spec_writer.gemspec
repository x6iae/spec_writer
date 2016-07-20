# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spec_writer/version'

Gem::Specification.new do |spec|
  spec.name          = "spec_writer"
  spec.version       = SpecWriter::VERSION
  spec.authors       = ["Sunday Adefila"]
  spec.email         = ["adefilaedward@gmail.com"]

  spec.summary       = %q{Automate Rspec test writing for common MVC specs}
	spec.description   = %q{Rspec model tests only comes with one line: 'pending "add some examples to (or delete) #{__FILE__}"'. T    his gem seeks to populate the model spec with basic tests like validations, relationships, etc...}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
