class GroupSerializer < ActiveModel::Serializer
  attributes :id, :groupname, :title
  attribute :users, if: :include_user?

  def include_user?
    instance_options[:include_users]
  end

  def users
    User.where(group_id: object.id)
  end
end
