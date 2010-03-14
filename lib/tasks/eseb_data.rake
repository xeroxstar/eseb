require 'ftools'
desc 'Create YAML test fixtures from data in an existing database.
  Defaults to development database.  Set RAILS_ENV to override.'

task :extract_fixtures => :environment do
  fixtures_dir = "#{RAILS_ROOT}/db/fixtures"
  unless File.exist?(fixtures_dir)
    File.makedirs(fixtures_dir)
  end
  sql  = "SELECT * FROM %s"
  skip_tables = ["schema_migrations"]
  ActiveRecord::Base.establish_connection
  (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
    i = "000"
    File.open("#{fixtures_dir}/#{table_name}.yml", 'w') do |file|
      data = ActiveRecord::Base.connection.select_all(sql % table_name)
      file.write data.inject({}) { |hash, record|
        hash["#{table_name}_#{i.succ!}"] = record
        hash
      }.to_yaml
    end
  end
end