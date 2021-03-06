
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'micro/case/version'

Gem::Specification.new do |spec|
  spec.name          = 'u-case'
  spec.version       = Micro::Case::VERSION
  spec.authors       = ['Rodrigo Serradura']
  spec.email         = ['rodrigo.serradura@gmail.com']

  spec.summary       = %q{Create simple and powerful use cases as objects.}
  spec.description   = %q{Create simple and powerful use cases as objects.}
  spec.homepage      = 'https://github.com/serradura/u-case'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    # spec.metadata["homepage_uri"] = spec.homepage
    # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|assets|benchmarks|comparisons|examples)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_runtime_dependency 'u-attributes', '~> 1.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
end
