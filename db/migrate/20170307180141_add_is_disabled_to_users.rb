class AddIsDisabledToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_disabled, :boolean
  end
end
