# frozen_string_literal: true

require_relative "lib/rails_cdn_optimizer/version"

Gem::Specification.new do |spec|
  spec.name = "rails-cdn-optimizer"
  spec.version = RailsCdnOptimizer::VERSION
  spec.authors = ["mrmalvi"]
  spec.email = ["malviyak00@gmail.com"]

  spec.summary       = "Rails CDN Optimizer: Analyze and optimize asset pipeline with CDN suggestions."
  spec.description   = "Rails Cdn Optimizer analyzes your Rails app's asset pipeline, detects large files, suggests CDN caching rules, and helps improve performance automatically."
  spec.homepage      = "https://github.com/mrmalvi/rails-cdn-optimizer"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.6.0"

  # Metadata for RubyGems.org
  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mrmalvi/rails-cdn-optimizer"
  spec.metadata["changelog_uri"]   = "https://github.com/mrmalvi/rails-cdn-optimizer/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
