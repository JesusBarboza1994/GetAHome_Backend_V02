class UsersController < ApplicationController
  before_action :require_login!, only: [:show, :update]
  def create 
    @user = User.new(user_params)
    p user_params
    if @user.save
      render json: @user.as_json(except: [:password_digest])
    else 
      errors = @user.errors
      render json: { errors: errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
    render json: @user.as_json(except: [:password_digest, :token])
  end

  def update 
    @user = User.find(current_user.id)
    if @user.update(user_params)
      render json:@user.as_json(except: [:password_digest, :token])
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:name, :phone, :user_type, :email, :password, :password_confirmation)
  end

  
end
