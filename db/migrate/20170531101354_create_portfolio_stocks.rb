class CreatePortfolioStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolio_stocks do |t|
      t.references :portfolio, index:true, foreign_key: true
      t.references :stock, index:true, foreign_key: true
      t.timestamps
    end
  end
end
