class RemovePasswordFromGroups < ActiveRecord::Migration[5.0]
  def change
    remove_column :groups, :password_hash
    remove_column :groups, :salt
  end
end
