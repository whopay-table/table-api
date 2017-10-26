class TransactionException < StandardError
  def initialize(errors)
    @errors = errors
  end
end

class Transaction < ApplicationRecord
  belongs_to :group
  belongs_to :from_user, :class_name => 'User'
	belongs_to :to_user, :class_name => 'User'
  belongs_to :created_user, :class_name => 'User'
  before_create :default_values
  after_create :reflect_to_accounts

  def self.new_many(params)
    errors = nil
    transactions = []

    begin
      Transaction.transaction do
        JSON.parse(params['from_user_ids']).each do |from_user_id|
          transaction = Transaction.new({
            group_id: params[:group_id],
            created_user_id: params[:created_user_id],
            from_user_id: from_user_id,
            to_user_id: params['to_user_id'],
            description: params['description'],
            amount: params['amount']
          })
          if transaction.save
            transactions.push(transaction)
          else
            errors = transaction.errors
            raise raise Exception.new()
          end
        end
      end
    rescue Exception => e
      return {errors: errors}
    end

    return {result: transactions}
  end

  def self.auto_accept
    Transaction.where(
      'is_accepted = ? AND auto_accept_at IS NOT NULL AND auto_accept_at < ?',
      false,
      DateTime.now
    ).update_attribute(:is_accepted, true)
  end

  def reject!
    Transaction.transaction do
      self.is_accepted = true
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
      unless self.is_accepted
        self.auto_accept_at = DateTime.now + 3.days
      end
    end

		def reflect_to_accounts
      Transaction.transaction do
  			self.from_user.decrement!(:balance, self.amount)
  			self.to_user.increment!(:balance, self.amount)
      end
		end
end
