module FixturesHelper
  def fixture_file(filename)
    File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', filename))
  end
end