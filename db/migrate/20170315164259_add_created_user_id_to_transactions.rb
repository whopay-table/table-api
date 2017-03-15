class AddCreatedUserIdToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :created_user_id, :integer
  end
end
