class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :accept, :reject]
  before_action :set_group, only: [:index, :show, :create, :accept, :reject]
  before_action :auth_from_user, only: [:accept, :reject]
  before_action :auth_group_member, only: [:index, :show, :create]

  # GET /groups/1/transactions
  def index
    @transactions = Transaction.where(group_id: @group.id)
    if params[:user_id]
      @transactions = @transactions.where('from_user_id = ? OR to_user_id = ?', params[:user_id], params[:user_id])
    end
    @transactions = @transactions.order(is_accepted: :desc, created_at: :desc)
    @transactions = @transactions.offset(params.require(:offset)).limit(params.require(:count))

    render json: @transactions
  end

  # GET /groups/1/transactions/1
  def show
    render json: @transaction
  end

  # POST /groups/1/transactions
  def create
    @transaction = Transaction.new({
      group_id: @group.id,
      created_user_id: @current_user.id
    }.merge(transaction_params))

    if @transaction.save
      render json: @transaction, status: :created, location: [@transaction.group, @transaction]
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # POST /groups/1/transactions/1/accept
  def accept
    @transaction.is_accepted = true
    @transaction.save!
    render json: @transaction
  end

  # POST /groups/1/transactions/1/reject
  def reject
    @transaction.reject!
    render json: @transaction
  end

  private
    def auth_from_user
      unless @current_user.id == @transaction.from_user_id
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
      params.require(:transaction).permit(:from_user_id, :to_user_id, :amount, :description)
    end
end
