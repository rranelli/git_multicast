require_relative '../lib/git_mass_do'

def fixture_path(filename)
  return '' if filename == ''
  File.join(File.absolute_path(File.dirname(__FILE__)), 'fixtures', filename)
end
