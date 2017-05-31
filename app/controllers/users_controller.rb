class UsersController < ApplicationController
	include SessionsHelper
  def create
  	@user = User.new(user_params)
  	if @user.save
  		if @user.remember_token 
  			sign_in_with_cookies(@user)
  		else 
  			sign_in(@user)
  		end
  		respond_to do |format|
  			format.js 
  		end
  	else
  		respond_to do |format|
  			format.js { render:'sign_up_errors', status: :unprocessable_entity }
  		end
  	end
  end

  private
  def user_params
  	params.require(:user).permit(:email, :username, :password, :password_confirmation, :remember_token)
  end
end
