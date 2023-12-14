# app/controllers/admin/users_controller.rb

class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Ejemplo de acciones CRUD
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path(@user), notice: 'User was successfully updated.'
    else
      redirect_to admin_users_path, alert: 'User was not updated.'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created..'
    else
      render :new
    end
  end


  private

  def authenticate_admin!
    unless current_user && current_user.admin?
      redirect_to root_path, alert: 'Access Denied.!'
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
                                  :first_name,
                                  :last_name,
                                  :email,
                                  :role,
                                  :photo,
                                  :password,
                                  :password_confirmation
                                  )
  end

end
