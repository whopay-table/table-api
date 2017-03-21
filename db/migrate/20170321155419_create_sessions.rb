class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.string :token
      t.timestamp :expire_at
      t.integer :user_id

      t.timestamps
    end
    add_index :sessions, :token
    add_index :sessions, :user_id
  end
end
