class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.string 			:uid
      t.string 			:token
      t.string 			:provider
      t.references 	:user
      t.timestamps
    end
  end
end
