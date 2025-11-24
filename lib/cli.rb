require 'tty-prompt'
require 'pastel'
require 'terminal-table'

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

        transactions = Transaction.includes(:category).order(date: :desc)

        if transactions.empty?
            puts @pastel.yellow("\nNenhuma transação encontrada.")
            return
        end

        rows = transactions.map do |t|
            [
                t.id,
                t.date.strftime("%d/%m/%Y"),
                t.description,
                t.category.name,
                format_money(t)
            ]
        end

        table = Terminal::Table.new do |t|
            t.title = "Extrato Financeiro"
            t.headings = ['ID', 'Data', 'Descrição', 'Categoria', 'Valor']
            t.rows = rows
            t.style = { border_x: "-", border_i: "+" }
        end

        puts "\n"
        puts table
        puts "\n"
    end

    def format_money(transaction)
        value = "R$ #{'%.2f' % transaction.amount}"
    
        if transaction.category.kind == 'income'
            @pastel.green(value)
        else
            @pastel.red("- #{value}")
        end
    end

    def summary
        puts @pastel.yellow("\n📊 Resumo Financeiro\n")

        total_income = Transaction.joins(:category).where(categories: { kind: 'income' }).sum(:amount)
        total_expense = Transaction.joins(:category).where(categories: { kind: 'expense' }).sum(:amount)
        balance = total_income - total_expense

        puts "Receitas: " + @pastel.green("R$ #{'%.2f' % total_income}")
        puts "Despesas: " + @pastel.red("R$ #{'%.2f' % total_expense}")
        puts "-" * 30
    
        label_saldo = "Saldo Final: "
            if balance >= 0
                puts label_saldo + @pastel.green.bold("R$ #{'%.2f' % balance}")
            else
                puts label_saldo + @pastel.red.bold("R$ #{'%.2f' % balance}")
            end

        puts "\n--- Detalhe por Categoria ---\n"
    
        category_totals = Category.joins(:transactions).group(:name, :kind).sum(:amount)

        if category_totals.empty?
             puts "Sem dados para exibir."
        else
            table = Terminal::Table.new do |t|
                t.headings = ['Categoria', 'Tipo', 'Total Acumulado']
                t.style = { border_x: "-", border_i: "+" }
        
            category_totals.each do |(name, kind), total|
            formatted_total = if kind == 'income'
                                @pastel.green("R$ #{'%.2f' % total}")
                              else
                                @pastel.red("R$ #{'%.2f' % total}")
                              end
          
            kind_label = kind == 'income' ? 'Receita' : 'Despesa'
          
            t.add_row [name, kind_label, formatted_total]
            end
        end
            puts table
        end
    end
end