class CreatePortfolios < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolios do |t|
    	t.belongs_to 	:user, index:true, foreign_key:true
    	t.string			:name
    	t.text				:description
    	t.string		 	:cash
      t.timestamps
    end
  end
end
