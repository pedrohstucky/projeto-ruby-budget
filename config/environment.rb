require 'bundler/setup'
require 'active_record'
require 'yaml'

db_config = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))

ActiveRecord::Base.establish_connection(db_config)

#ActiveRecord::Base.logger = Logger.new(STDOUT)