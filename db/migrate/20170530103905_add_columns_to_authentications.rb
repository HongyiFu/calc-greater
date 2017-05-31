class AddColumnsToAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :refresh_token, :string
    add_column :authentications, :expires_at, :datetime
  end
end
