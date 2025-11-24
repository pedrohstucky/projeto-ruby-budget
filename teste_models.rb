require_relative 'config/environment'

puts "--- Testando Criação de Dados ---"

begin
  # 1. Tenta criar uma categoria
  alimentacao = Category.create!(name: 'Alimentação', kind: 'expense')
  puts "✅ Categoria Criada: #{alimentacao.name} (ID: #{alimentacao.id})"

  # 2. Tenta criar uma transação vinculada a essa categoria
  almoco = Transaction.create!(
    description: 'Almoço no Restaurante',
    amount: 35.50,
    date: Date.today,
    category: alimentacao
  )
  puts "✅ Transação Criada: #{almoco.description} - R$ #{almoco.amount}"

  # 3. Verifica a relação (A categoria sabe suas transações?)
  puts "Total de transações em Alimentação: #{alimentacao.transactions.count}"

rescue ActiveRecord::RecordInvalid => e
  puts "❌ Erro de Validação: #{e.record.errors.full_messages.join(', ')}"
rescue StandardError => e
  puts "❌ Erro: #{e.message}"
end