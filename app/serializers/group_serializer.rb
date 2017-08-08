class GroupSerializer < ActiveModel::Serializer
  attributes :id, :groupname, :title, :signup_key
  has_many :users
end
