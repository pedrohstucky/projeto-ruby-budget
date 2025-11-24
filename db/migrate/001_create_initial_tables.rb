class CreateInitialTables < ActiveRecord::Migration[7.1]
  def change
    # 1. Tabela de Categorias
    create_table :categories do |t|
      t.string :name, null: false
      t.string :kind, null: false
    end

    # 2. Tabela de Transações
    create_table :transactions do |t|
      t.string :description, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :date, null: false
      
      # Chave estrangeira ligando à categoria
      t.references :category, foreign_key: true
    end
  end
end