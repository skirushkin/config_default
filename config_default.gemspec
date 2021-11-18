# frozen_string_literal: true

require_relative "lib/config_default/version"

Gem::Specification.new do |spec|
  spec.name = "config_default"
  spec.version = ConfigDefault::VERSION
  spec.authors = ["Stepan Kirushkin"]
  spec.email = ["stepan.kirushkin@gmail.com"]

  spec.summary = "A simple way to manage default and env configuration in Rails."
  spec.description = <<-TXT
    ConfigDefault add an ability to separate your configuration on *.default.yml and *.yml files.
    It's very useful to mix in configuration when you deploy your application.
  TXT

  spec.homepage = "https://github.com/skirushkin/config_default"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/skirushkin/config_default/blob/master/CHANGELOG.md"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.include?("spec") }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 6"
end
