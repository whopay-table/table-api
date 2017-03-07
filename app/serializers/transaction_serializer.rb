class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :is_accepted, :is_rejected
  attribute :from_user
  attribute :to_user

  def from_user
    User.find(object.from_user_id)
  end

  def to_user
    User.find(object.to_user_id)
  end
end
