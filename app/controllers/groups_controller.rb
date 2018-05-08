class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    find_group_and_check_permission
    if @group.update(group_params)
      redirect_to groups_path, notice: "更新成功！"
    else
      render :edit
    end
  end

  def destroy
    find_group_and_check_permission
    @group.destroy
    flash[:alert] = "删除成功！"
    redirect_to groups_path
  end

  def edit
    find_group_and_check_permission
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "您没有权限进行该操作！"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
