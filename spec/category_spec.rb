require 'spec_helper'

RSpec.describe Category, type: :model do
  context 'Validações' do
    it 'é válido com atributos corretos' do
      category = Category.new(name: 'Salário', kind: 'income')
      expect(category).to be_valid
    end

    it 'é inválido sem nome' do
      category = Category.new(name: nil, kind: 'expense')
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'é inválido com tipo desconhecido' do
      category = Category.new(name: 'Teste', kind: 'coisa_estranha')
      expect(category).not_to be_valid
      expect(category.errors[:kind]).to include("coisa_estranha não é um tipo válido")
    end
  end
end