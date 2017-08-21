class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :account_info, :balance, :is_admin, :group_id
end
