class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :set_admin, :show_signup_key, :reset_signup_key, :destroy]
  before_action :set_user, only: [:set_admin]
  before_action :auth_admin, only: [:update, :show_signup_key, :reset_signup_key, :destroy]
  skip_before_action :auth, :only => [:create]

  # GET /groups
  def index
    @groups = Group.all

    render json: @groups
  end

  # GET /groups/1
  def show
    render json: @group
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      @user = User.new({
        group_id: @group.id,
        is_admin: true
      }.merge(user_params))

      if @user.save
        render json: @group, status: :created, location: @group
      else
        @group.destroy
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # GET /groups/1/signup_key
  def show_signup_key
    render json: { signup_key: @group.signup_key }
  end

  # POST /groups/1/signup_key/reset
  def reset_signup_key
    @group.reset_signup_key
    @group.save!
    render json: { signup_key: @group.signup_key }
  end

  # POST /groups/1/set_admin
  def set_admin
    if @user
      @group.set_admin(@user)
      render json: @user
    else
      render_invalid_params keys: ['user_id']
    end
  end

  # DELETE /groups/1
  def destroy
    # TODO: Do not destroy when there is user with balance != 0 or trasaction with accepted == false.
    @group.destroy
  end

  private
    def auth_admin
      @is_admin = @current_user.group_id == @group.id && @current_user.is_admin
      unless @is_admin
        render_forbidden
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:groupname, :title)
    end

    def user_params
      params.require(:user).permit(
        :email, :username, :name, :account_info, :password, :password_confirmation)
    end
end
