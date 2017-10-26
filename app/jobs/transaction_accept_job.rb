class TransactionAcceptJob < ActiveJob::Base
  def perform
    Transaction.auto_accept
  end
end
