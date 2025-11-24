require_relative 'config/environment'

puts "Verificando tabelas no banco de dados..."
puts "-" * 30

tabelas = ActiveRecord::Base.connection.tables

if tabelas.include?('transactions') && tabelas.include?('categories')
  puts "✅ Tabelas encontradas: #{tabelas.join(', ')}"
else
  puts "❌ Algo deu errado. Tabelas encontradas: #{tabelas}"
end