class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :accept, :reject]
  before_action :set_group, only: [:index, :show, :create, :accept, :reject]
  before_action :auth_transaction_user, only: [:reject]
  before_action :auth_transaction_from_user, only: [:accept]
  before_action :auth_pending_transaction, only: [:accept, :reject]
  before_action :auth_group_member, only: [:index, :show, :create]

  # GET /groups/1/transactions
  def index
    @transactions = Transaction.where(group_id: @group.id)
    if params[:user_id]
      @transactions = @transactions.where('from_user_id = ? OR to_user_id = ?', params[:user_id], params[:user_id])
      @transactions = @transactions.order(created_at: :desc, is_accepted: :desc)
    else
      @transactions = @transactions.order(created_at: :desc)
    end

    @transactions = @transactions.offset(params.require(:offset)).limit(params.require(:count))

    render json: @transactions, include: 'from_user,to_user'
  end

  # GET /groups/1/transactions/1
  def show
    render json: @transaction, include: 'from_user,to_user'
  end

  # POST /groups/1/transactions
  def create
    if transaction_params[:amount].to_f <= 0
      render_model_errors({ amount: 'should be bigger than 0' })
      return
    end

    if transaction_params[:from_user_ids]
      @transactions = Transaction.new_many({
        group_id: @group.id,
        created_user_id: @current_user.id
      }.merge(transaction_params))
      if @transactions[:result]
        if @transactions[:result].empty?
          render json: []
        else
          render json: @transactions[:result], include: 'from_user,to_user', status: :created,
            location: [@group, @transactions[:result].first]
        end
      else
        render_model_errors @transactions[:errors]
      end
    else
      @transaction = Transaction.new({
        group_id: @group.id,
        created_user_id: @current_user.id
      }.merge(transaction_params))

      if @transaction.save
        render json: @transaction, include: 'from_user,to_user', status: :created, location: [@group, @transaction]
      else
        render_model_errors @transaction.errors
      end
    end
  end

  # POST /groups/1/transactions/1/accept
  def accept
    @transaction.is_accepted = true
    @transaction.save!
    render json: @transaction, include: 'from_user,to_user'
  end

  # POST /groups/1/transactions/1/reject
  def reject
    @transaction.reject!
    render json: @transaction, include: 'from_user,to_user'
  end

  private
    def auth_transaction_from_user
      unless @current_user.id == @transaction.from_user_id
        render_forbidden
      end
    end

    def auth_transaction_user
      unless @current_user.id == @transaction.from_user_id || @current_user.id == @transaction.to_user_id
        render_forbidden
      end
    end

    def auth_pending_transaction
      if @transaction.is_accepted
        render_forbidden
      end
    end

    def auth_group_member
      unless @current_user.group_id == @group.id
        render_forbidden
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:from_user_id, :from_user_ids, :to_user_id, :amount, :description)
    end
end
