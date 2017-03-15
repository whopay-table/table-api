class Transaction < ApplicationRecord
  belongs_to :group
  belongs_to :from_user, :class_name => 'User'
	belongs_to :to_user, :class_name => 'User'
  belongs_to :created_user, :class_name => 'User'
  after_create :reflect_to_accounts

  def reject!
    self.is_rejected = true
    Transaction.transaction do
      self.from_user.increment!(:balance, self.amount)
      self.to_user.decrement!(:balance, self.amount)
      self.save!
    end
  end

	private
		def reflect_to_accounts
      Transaction.transaction do
  			self.from_user.decrement!(:balance, self.amount)
  			self.to_user.increment!(:balance, self.amount)
      end
		end
end
