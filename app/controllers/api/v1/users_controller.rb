class Api::V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render json: {
      name: user.name,
      email: user.email
    }
  end

  def create
    user = User.create!(user_params)
    render json: {
      name: user.name,
      email: user.email
    }
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
