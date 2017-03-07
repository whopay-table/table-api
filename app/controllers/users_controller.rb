class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_group, only: [:create]
  before_action :auth_current_user, only: [:update, :destroy]
  before_action :auth_group_signup, only: [:create]
  skip_before_action :auth, :only => [:create]

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new({ group_id: @group.id }.merge(user_params))

    if @user.save
      render json: @user, status: :created, location: [@user.group, @user]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
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
