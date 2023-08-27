class SessionsController < ApplicationController
    def create
      user = User.find_by(username: params[:username])
      
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        render json: {
          id: user.id,
          username: user.username,
          image_url: user.image_url, # Add the actual attribute name for image URL
          bio: user.bio              # Add the actual attribute name for bio
        }
      else
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end
    end
  
    def destroy
        if current_user
          session[:user_id] = nil
          head :no_content
        else
          render json: { message: 'Unauthorized' }, status: :unauthorized
        end
      end
  end
  