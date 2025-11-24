class Category < ActiveRecord::Base
    has_many :transactions

    validates :name, presence: true
    validates :kind, presence: true, inclusion: { in: %w[income expense], message: "%{value} não é um tipo válido" }
end