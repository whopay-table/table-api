class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_group, only: [:index, :create]
  before_action :auth_current_user, only: [:update, :destroy]
  before_action :auth_group_signup, only: [:index, :create]
  before_action :auth_group_member, only: [:show]
  skip_before_action :auth, :only => [:index, :create]

  # GET /groups/1/users?username=user1 OR
  # GET /groups/1/users?email=user1@table.api
  def index
    if !params.has_key?(:username) && !params.has_key?(:email)
      render_model_errors model_errors: {
        username: 'or email is required' ,
        email: 'or username is required'
      }
      return
    elsif params.has_key?(:username) && params.has_key?(:email)
      render_model_errors model_errors: {
        username: 'should not be there when email is given' ,
        email: 'should not be there when username is given'
      }
      return
    end
    if params[:username]
      @user = User.find_by(username: params[:username])
      if @user
        render json: { id: @user.id }
      else
        render_model_errors model_errors: { username: 'is not found' }
      end
    elsif params[:email]
      @user = User.find_by(email: params[:email])
      if @user
        render json: { id: @user.id }
      else
        render_model_errors model_errors: { email: 'is not found' }
      end
    end
  end

  # GET /groups/1/users/1
  def show
    render json: @user
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
    if @user.update(user_params)
      render json: @user
    else
      render_model_errors @user.errors
    end
  end

  # DELETE /groups/1/users/1
  def destroy
    if @user.balance != 0
      render_model_errors model_errors: { id: 'has balance not 0' }
      return
    elsif @user.transactions.select{ |transaction| not transaction.is_accepted }.any?
      render_model_errors model_errors: { id: 'has trancation not accepted' }
      return
    end
    @user.is_disabled = true
    @user.save!
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
        :email, :username, :name, :account_info, :password, :password_confirmation)
    end

    def group_signup_key
      params[:group_signup_key]
    end
end
