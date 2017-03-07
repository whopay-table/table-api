class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :amount
      t.string :description
      t.boolean :is_accepted
      t.boolean :is_rejected

      t.timestamps
    end
  end
end
