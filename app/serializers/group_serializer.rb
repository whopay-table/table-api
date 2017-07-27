class GroupSerializer < ActiveModel::Serializer
  attributes :id, :groupname, :title, :signup_key
  attribute :users, if: :include_user?

  def include_user?
    instance_options[:include_users]
  end

  def users
    User.select(:id, :email, :username, :name, :balance).where(group_id: object.id)
  end
end
