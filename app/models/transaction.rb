class Transaction < ApplicationRecord
  belongs_to :group
  belongs_to :from_user, :class_name => 'User'
	belongs_to :to_user, :class_name => 'User'
  belongs_to :created_user, :class_name => 'User'
  before_create :default_values
  after_create :reflect_to_accounts

  def reject!
    Transaction.transaction do
      self.is_rejected = true
      self.from_user.increment!(:balance, self.amount)
      self.to_user.decrement!(:balance, self.amount)
      self.save!
    end
  end

	private
    def default_values
      self.is_accepted = self.created_user_id == self.from_user_id
      self.is_rejected = false
    end

		def reflect_to_accounts
      Transaction.transaction do
  			self.from_user.decrement!(:balance, self.amount)
  			self.to_user.increment!(:balance, self.amount)
      end
		end
end
