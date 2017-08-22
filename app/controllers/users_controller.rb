class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_group, only: [:index, :create, :update, :destroy, :reset_password]
  before_action :auth_current_user, only: [:update, :destroy]
  before_action :auth_group_signup, only: [:index, :create]
  before_action :auth_group_member, only: [:show]
  skip_before_action :auth, :only => [:index, :create, :reset_password]

  # GET /groups/1/users?email=user1@table.api
  def index
    if !params.has_key?(:email)
      render_model_errors({ email: 'is required' })
      return
    end

    @user = User.find_by(email: params[:email], group_id: @group.id)
    if @user
      render json: { id: @user.id }
    else
      render_model_errors({ email: 'is not found' })
    end
  end

  # GET /groups/1/users/1
  def show
    render json: @user
  end

  # POST /groups/1/users/reset_password?email=user1@table.api
  def reset_password
    @user = User.find_by(email: params[:email], group_id: @group.id)

    if @user
      password = @user.reset_password
      UserMailer.reset_password(@group, @user, password)
      render json: @user
    else
      render_model_errors({ user: 'is not found' })
    end

  end

  # POST /groups/1/users
  def create
    @user = User.new({ group_id: @group.id }.merge(user_params))

    if @user.save
      render json: @user, status: :created, location: [@user.group, @user]
    else
      render_model_errors @user.errors
    end
  end

  # PATCH/PUT /groups/1/users/1
  def update
    unless @user.authenticate(params[:password])
      render json: {
        errors: [ { code: 'password_fail', message: 'Authentication fail' } ]
      }, status: :unauthorized
      return
    end

    user = User.find_by(email: user_params[:email], group_id: @group.id)
    if user && (user.id != @user.id)
      render_invalid_params keys: ['email']
      return
    end

    if @user.update(user_params)
      render json: @user
    else
      render_model_errors @user.errors
    end
  end

  # DELETE /groups/1/users/1
  def destroy
    unless @user.authenticate(params[:password])
      render json: {
        errors: [ { code: 'password_fail', message: 'Authentication fail' } ]
      }, status: :unauthorized
      return
    end

    if @user.balance != 0
      render_model_errors({ id: 'has balance not 0' })
      return
    elsif Transaction.where(from_user_id: @user.id, is_accepted: false).any?
      render_model_errors({ id: 'has transaction not accepted' })
      return
    elsif Transaction.where(to_user_id: @user.id, is_accepted: false).any?
      render_model_errors({ id: 'has transaction not accepted' })
      return
    end
    @user.is_disabled = true
    @user.save!

    render_succeed
  end

  private
    def auth_current_user
      unless @current_user.id == @user.id
        render_forbidden
      end
    end

    def auth_group_signup
      unless @group.signup_key == group_signup_key
        render_forbidden
      end
    end

    def auth_group_member
      unless @current_user.group_id == @user.group_id
        render_forbidden
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(
        :email, :name, :account_info, :password, :password_confirmation)
    end

    def group_signup_key
      params[:group_signup_key]
    end
end
