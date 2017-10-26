class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :is_accepted, :is_rejected, :created_at, :auto_accept_at
  has_one :from_user
  has_one :to_user
end
