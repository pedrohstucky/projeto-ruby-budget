class Transaction < ActiveRecord::Base
    belongs_to :category
    
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :description, presence: true
    validates :date, presence: true
end