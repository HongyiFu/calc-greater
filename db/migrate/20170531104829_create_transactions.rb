class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.references :portfolio, index:true, foreign_key:true
      t.references :stock, index:true, foreign_key:true
      t.integer    :status, default: 0
      t.string     :price
      t.integer    :volume
      t.timestamps
    end
  end
end
