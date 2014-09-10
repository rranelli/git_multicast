lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'git_multicast/version'

Gem::Specification.new do |spec|
  spec.name = 'git_multicast'
  spec.version = GitMulticast::VERSION
  spec.required_ruby_version = '~>2.0'

  spec.summary  = 'Execute mass actions on git repositories concurrently'
  spec.authors  = ['Renan Ranelli']
  spec.email    = ['renanranelli@gmail.com']
  spec.homepage = 'http://github.com/rranelli/git_multicast'
  spec.license  = 'DWTF'

  spec.files       = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'recursive-open-struct', '~> 0.5.0'
  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 10.0'

  # these gems are required by emacs' robe-package
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'method_source'
end
