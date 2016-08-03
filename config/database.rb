Sequel.extension :pg_array, :pg_json, :pg_json_ops, :pg_inet
Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
DB = Sequel::Model.db = case Padrino.env
  when :development then Sequel.connect("postgres://postgres:changeme@postgresdb/honeybadger_development", :loggers => [logger])
  when :production  then Sequel.connect("postgres://postgres:changeme@postgresdb/honeybadger_production",  :loggers => [logger])
  when :test        then Sequel.connect("postgres://postgres:changeme@postgresdb/honeybadger_development",        :loggers => [logger])
end
Sequel::Model.db.extension(:pagination)
Sequel::Model.strict_param_setting = false

DB.extension(:connection_validator)
DB.pool.connection_validation_timeout = -1