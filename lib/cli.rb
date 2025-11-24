require 'tty-prompt'
require 'pastel'

class CLI
    def initialize
        @prompt = TTY::Prompt.new
        @pastel = Pastel.new
    end

    def start
        system 'clear'
        puts @pastel.green.bold("Bem-vindo ao RubyBudget!")
        puts "Organize sua vida financeira.\n\n"

        loop do
            escolha = @prompt.select("O que você deseja fazer?", cycle: true) do |menu|
                menu.choice 'Nova Transação', :new_transaction
                menu.choice 'Ver Extrato', :list_transactions
                menu.choice 'Resumo por Categoria', :summary
                menu.choice 'Sair', :exit
            end

            break if escolha == :exit

            send(escolha)
        end

        puts @pastel.blue("Até logo!")
    end

    private

    def new_transaction
        puts @pastel.yellow("\n--- Nova Transação ---")

        description = @prompt.ask("Descrição (ex: Almoço Salário): ", required: true)

        amount = @prompt.ask("Valor (R$): ", convert: :float) do |q|
            q.required true
            q.validate { |input| input.to_f > 0 }
            q.messages[:valid?] = "O valor deve ser maior que zero!"
        end

        date = @prompt.ask("Data (DD-MMM-YYYY): ", default: Date.today.to_s)

        category = select_category_flow

        transaction = Transaction.new(
            description: description,
            amount: amount,
            date: date,
            category: category
        )

        if transaction.save
            puts @pastel.green("\nTransação registrada com sucesso!")
            puts "      #{transaction.description} | R$ #{transaction.amount} | #{category.name}"
        else
            puts @pastel.red("\nErro ao salvar: #{transaction.errors.full_messages.join(', ')}")
        end
    end

    def select_category_flow
        categories = Category.all

        choices = categories.map { |c| ["#{c.name} (#{c.kind})", c] }.to_h

        choices["Criar Nova Categoria"] = :new_category

        selection = @prompt.select("Selecione a Categoria: ", choices, per_page: 10)

        if selection == :new_category
            create_category_flow
        else
            selection
        end
    end

    def create_category_flow
        puts @pastel.yellow("\n--- Nova Categoria ---")

        name = @prompt.ask("Nome da Categoria: ", required: true)

        kind = @prompt.select("Tipo: ", { "Despesa (Expense)" => "expense", "Receita (Income)" => "income" })

        category = Category.create(name: name, kind: kind)

        if category.persisted?
            puts @pastel.green("Categoria '#{category.name}' criada!")
            category
        else
            puts @pastel.red("Erro ao criar categoria.")
            create_category_flow
        end
    end

    def list_transactions
        puts "\nFuncionalidade 'Ver Extrato' em construção..."
        sleep 1
    end

    def summary
        puts "\nFuncionalidade 'Resumo' em construção..."
        sleep 1
    end
end