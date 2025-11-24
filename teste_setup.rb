require_relative 'config/environment'

begin
  # Tenta obter a versão do banco de dados
  version = ActiveRecord::Base.connection.execute("SELECT sqlite_version()").first[0]
  
  puts "\n" + ("=" * 50)
  puts "✅ SUCESSO! Ambiente configurado."
  puts "   - Ruby Version: #{RUBY_VERSION}"
  puts "   - SQLite Version: #{version}"
  puts "   - Banco de dados configurado em: db/budget.sqlite3"
  puts ("=" * 50) + "\n"
rescue StandardError => e
  puts "❌ ERRO: #{e.message}"
end