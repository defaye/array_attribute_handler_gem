# frozen_string_literal: true

require_relative "lib/array_attribute_handler/version"

Gem::Specification.new do |spec|
  spec.name = "array_attribute_handler"
  spec.version = ArrayAttributeHandler::VERSION
  spec.authors = ["Jono Feist"]
  spec.email = ["j78258334@gmail.com"]

  spec.summary = "A Ruby on Rails concern to handle string attributes as arrays with various options."
  spec.description = "The `handle_array_attribute` concern provides a flexible way to treat string attributes in a Rails model as arrays. This includes parsing strings based on configurable separators, optional spaces between elements, and optional maximum length validation for each element."
  spec.homepage = "https://github.com/defaye/handle_array_attribute_gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/defaye/handle_array_attribute_gem"
  spec.metadata["changelog_uri"] = "https://github.com/defaye/handle_array_attribute_gem/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "sqlite3"

  spec.add_dependency "activerecord", ">= 6.0", "< 7"
  spec.add_dependency "activesupport", ">= 6.0", "< 7"
end
