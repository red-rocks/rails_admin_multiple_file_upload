# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_admin_multiple_file_upload/version'

Gem::Specification.new do |gem|
  gem.name          = "rails_admin_multiple_file_upload"
  gem.version       = RailsAdminMultipleFileUpload::VERSION
  gem.authors       = ["Alexander Kiseliev"]
  gem.email         = ["i43ack@gmail.com"]
  gem.description   = %q{Rails admin multiple file upload with AJAX and DnD}
  gem.summary       = %q{Interface for uploading files for rails_admin}
  gem.homepage      = "https://github.com/ack43/rails_admin_multiple_file_upload"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.10"
  gem.add_development_dependency "rake", "~> 10.0"

  gem.add_dependency "rails_admin", "~> 0.8.1"
  gem.add_dependency 'dropzonejs-rails', "~> 0.7.3"
end
