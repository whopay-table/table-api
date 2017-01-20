class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :groupname
      t.string :title
      t.string :password_hash
      t.string :salt

      t.timestamps
    end
  end
end
