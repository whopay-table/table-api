class AddGroupIdToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :group_id, :integer
  end
end
