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
        puts "\nFuncionalidade 'Nova Transação' em construção..."
        sleep 1
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