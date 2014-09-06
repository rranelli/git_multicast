lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'git_multicast/version'

Gem::Specification.new do |s|
  s.name = 'git_multicast'
  s.version = GitMulticast::VERSION
  s.required_ruby_version = '~>2.0'

  s.summary  = 'Execute mass actions on git repositories concurrently'
  s.authors  = ['Renan Ranelli']
  s.email    = ['renanranelli@gmail.com']
  s.homepage = 'http://github.com/rranelli/git_multicast'
  s.license  = 'DWTF'

  s.files       = `git ls-files -z`.split("\x0")
  s.executables = s.files.grep(/^bin\//) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'recursive-open-struct', '~> 0.5.0'
  s.add_dependency 'thor', '~> 0.19'

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'pry'
end
