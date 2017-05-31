class Portfolio < ApplicationRecord
	
	validates :name, presence:true
	validates :description, presence:true
	validates	:cash, presence:true
	
	before_validation	:ensure_cash_in_correct_format

	belongs_to :user
	has_many :portfolio_stocks
	has_many :stocks, through: :portfolio_stocks
	has_many :transactions

	def update_portfolio
		last_transaction = self.transactions.last
		amount = last_transaction.transaction_amount
		if last_transaction.buy?
			self.update(cash:self.cash - amount)
		else 
			self.update(cash:self.cash + amount)
		end
	end

	def ensure_cash_in_correct_format
		self.cash.gsub!(/[^\d\.-]/,'')
		self.cash = self.cash.to_f
		self.cash = self.cash.to_s
	end
end
