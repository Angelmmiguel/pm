require File.expand_path('../lib/pmanager/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'pmanager'
  s.version     = Pmanager::VERSION
  s.executables << 'pm'
  s.summary     = 'The easy way to switch to your projects on the shell'
  s.description = 'The easy way to switch to your projects on the shell'
  s.authors     = ['Angel M Miguel']
  s.email       = 'angel@laux.es'
  s.files       = Dir['{bin,lib}/**/*'] + %w(LICENSE README.md)
  s.homepage    = 'http://irb.rocks'
  s.require_paths = %w(lib bin)
  s.licenses     = 'MIT'

  # Dependencies
  s.add_dependency 'thor', '~> 0.19.1'
  s.add_dependency 'rainbow', '~> 2.1.0', '>= 2.1.0'
end
