class Transaction < ApplicationRecord
	belongs_to :stock
	belongs_to :portfolio

	enum status: { buy: 0, sell: 1 }

	def transaction_amount 
		price * volume
	end
end
