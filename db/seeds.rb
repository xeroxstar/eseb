require 'open-uri'
require 'active_record/fixtures'

Country.delete_all
open("http://openconcept.ca/sites/openconcept.ca/files/country_code_drupal_0.txt") do |countries|
  countries.read.each_line do |country|
    code, name = country.chomp.split("|")
    Country.create!(:name => name, :code => code)
  end
end

Category.delete_all
Fixtures.create_fixtures("#{RAILS_ROOT}/spec/fixtures", "categories")

#Fixtures.create_fixtures("#{RAILS_ROOT}/test/fixtures", "countries")

# load fixture to database
#Dir.glob(File.join(RAILS_ROOT, 'db', dir, '*.yml')).each do |fixture_file|
#  table_name = File.basename(fixture_file, '.yml')
#
#  if table_empty?(table_name) || always
#    truncate_table(table_name)
#    Fixtures.create_fixtures(File.join('db/', dir), table_name)
#  end
#end