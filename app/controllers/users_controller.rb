class UsersController < ApplicationController

   def welcome
   end

   def profile
      if !session[:user_id]
         redirect_to welcome_path
      else
         @current_user = User.find(session[:user_id])
      end
   end
   
   def account
      if !session[:user_id]
         redirect_to welcome_path
      else
         @current_user = User.find(session[:user_id])
      end
   end

   def logout
      flash[:notice]  = "Successfully Logged Out!"
      session[:user_id] = nil
      cookies.delete :auth_token
      cookies.delete :typo_user_profile
      redirect_to :action => 'welcome'
   end

   def signup
      if request.xhr?
         flash[:ajax] = true
      else
         flash[:ajax] = false
      end
      if request.post?
         if params[:confirm_password] == params[:password]
            new_params = signup_params()
            user = User.new(new_params)
            if user.valid?
               user.save
               puts "VALID USER"
               session[:user_id] = user.id
               redirect_to root_path
            else
               puts user.errors.messages[:email] + user.errors.messages[:username]
               error_mess = "Error: "
               if user.errors.messages[:email] and user.errors.messages[:email].length > 0
                  error_mess += user.errors.messages[:email][0] + ' '
               end
               if user.errors.messages[:username] and user.errors.messages[:username].length > 0
                  error_mess += user.errors.messages[:username][0]
               end
               flash[:error] = error_mess
            end
         else
            flash[:error] = "Your Passwords do not match!"
         end
      end
   end

   def login
      if request.xhr?
         flash[:ajax] = true
      else
         flash[:ajax] = false
      end
      if request.post?
         user = User.authenticate(params[:username], params[:password])
         if user
            session[:user_id] = user.id
            redirect_to root_path
         else
            flash[:error] = 'No Login Found, Try Again!'
         end
      end
   end


   protected

   def signup_params
      params.permit(:username, :password, :name, :email).except(:confirm_password)
   end

   def login_params
      params.permit(:username, :password)
   end

end
