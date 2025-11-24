# 💰 RubyBudget

Um gerenciador de finanças pessoais via linha de comando (CLI), desenvolvido em Ruby puro.
Este projeto demonstra o uso de **ActiveRecord** fora do Rails, migrações de banco de dados, testes com **RSpec** e interface interativa.

## 🚀 Funcionalidades

- [x] Cadastro de Transações (Receitas e Despesas).
- [x] Criação dinâmica de Categorias.
- [x] Extrato detalhado com tabela colorida.
- [x] Relatório de Saldo e agrupamento por Categoria.
- [x] Persistência de dados com SQLite3.

## 🛠️ Tecnologias

- **Linguagem:** Ruby 3.4.7
- **Database:** SQLite3 + ActiveRecord 7.1
- **CLI:** tty-prompt, pastel, terminal-table
- **Testes:** RSpec

## 📦 Como rodar o projeto

1. **Clone o repositório:**
   ```bash
   git clone git@github.com:pedrohstucky/projeto-ruby-budget.git
   cd ruby_budget

2. Instale as dependências:
    ```bash
    bundle install

3. Configure o Banco de Dados:
    ```bash
    bundle exec rake migrate

4. Execute o programa
    ```bash
    bin/budget

5. (Opcional) Rode os testes:
    ```bash
    bundle exec rspec