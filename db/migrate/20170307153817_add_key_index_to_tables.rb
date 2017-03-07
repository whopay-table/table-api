class AddKeyIndexToTables < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :api_key
    add_index :groups, :signup_key
  end
end
