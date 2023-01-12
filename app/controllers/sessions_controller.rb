class SessionsController < ApplicationController
  before_action :require_login!, only: [:destroy]
    def create 
      @user = User.find_by(email: params[:email])

      if @user && @user.authenticate(params[:password])
        # Save the user id inside the browser cookie. This is how we keep the user 
        # logged in when they navigate around our website.
        # session[:user_id] = @user.id
        @user.update_token
        render json: @user.as_json(except: [:password_digest])
      else
        render_unauthorized('Incorrect email or password')
      end
    end
  
    def destroy
      current_user.invalidate_token
    end

  end