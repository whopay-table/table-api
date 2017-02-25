class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy]
  skip_before_action :authenticate, :only => [:create]

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
      @user = User.new({ :group_id => @group.id }.merge(user_params))

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

  # DELETE /groups/1
  def destroy
    @group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:groupname, :title, :password, :password_confirmation)
    end

    def user_params
      params.require(:user).permit(
        :email, :username, :name, :account_info, :balance,
        :is_admin, :password, :password_confirmation, :string)
    end
end
