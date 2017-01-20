class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :name
      t.string :account_info
      t.integer :balance
      t.boolean :is_admin
      t.string :password_hash
      t.string :salt
      t.string :string
      t.belongs_to :group, foreign_key: true

      t.timestamps
    end
  end
end
