# app/controllers/admin/users_controller.rb

class Admin::UsersController < ApplicationController
  # Autenticación de usuario administrador
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Ejemplo de acciones CRUD
  def index
    #Orden de usuarios por rol, nombre y 5 usuarios por página
    @pagy, @users = pagy(User.order("role DESC, first_name"), items: 5)

  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    create_or_delete_users_tags(@user, params[:user][:tags],)

    if @user.update(user_params.except(:tags))
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
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
    @user = User.new(user_params.except(:tags))
    create_or_delete_users_tags(@user, params[:user][:tags],)


    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
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

  # Utilidad para encontrar y asignar el usuario correcto según el ID proporcionado
  def set_user
    @user = User.find(params[:id])
  end

  def create_or_delete_users_tags(user, tags)
    user.taggables.destroy_all
      tags = tags.strip.split(',')
      tags.each do |tag|
      user.tags << Tag.find_or_create_by(name: tag)
    end
  end

  def user_params
    params.require(:user).permit(
                                  :first_name,
                                  :last_name,
                                  :email,
                                  :role,
                                  :photo,
                                  :password,
                                  :password_confirmation,
                                  :tags
                                  )
  end

end
