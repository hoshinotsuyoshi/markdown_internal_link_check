# frozen_string_literal: true

require_relative "lib/markdown_internal_link_check/version"

Gem::Specification.new do |spec|
  spec.name = "markdown_internal_link_check"
  spec.version = MarkdownInternalLinkCheck::VERSION
  spec.authors = ["hoshinotsuyoshi"]
  spec.email = ["guitarpopnot330@gmail.com"]

  spec.summary = <<~EOF
    Check all internal links in markdown text to determine if they are alive or dead
  EOF
  spec.homepage = "https://github.com/hoshinotsuyoshi/markdown_internal_link_check"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # spec.metadata["allowed_push_host"] = "Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "commonmarker"

  spec.metadata['rubygems_mfa_required'] = 'true'
end
