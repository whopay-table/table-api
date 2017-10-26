class AddAutoAcceptAtToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :auto_accept_at, :datetime
  end
end
