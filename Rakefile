require_relative 'config/environment'
require 'active_record'

desc 'Migrar o banco de dados'
task :migrate do
  # Pega o POOL de conexões
  pool = ActiveRecord::Base.connection_pool

  # Instancia as classes de controle passando o pool
  schema_migration = ActiveRecord::SchemaMigration.new(pool)
  internal_metadata = ActiveRecord::InternalMetadata.new(pool)

  # Cria o contexto de migração
  context = ActiveRecord::MigrationContext.new(
    'db/migrate',
    schema_migration,
    internal_metadata
  )

  # Executa
  context.migrate
  puts "✅ Migração concluída com sucesso!"
end