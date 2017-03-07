class AddSignupKeyToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :signup_key, :string
  end
end
