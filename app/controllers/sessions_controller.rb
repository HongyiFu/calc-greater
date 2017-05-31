class SessionsController < ApplicationController
	include SessionsHelper

	def create
		@user = User.find_by_email(params[:email])
		if @user && @user.password_digest.nil?
			respond_to do |format|
				format.js { render:'redirect', status:401 } 
			end
		elsif @user && !@user.password_digest.nil? && @user.authenticate(params[:password])
			if params[:remember_token].present?
				sign_in_with_cookies(@user)
			else 
				sign_in(@user)
			end
			respond_to do |format|
				format.js 
			end
		else 
			respond_to do |format|
				format.js { render:'sign_in_errors', status:401 } 
			end
		end
	end

	def destroy
		sign_out
		redirect_to root_path, info:"You have signed out."
	end

	def create_from_omniauth
    auth_hash = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
    email = auth_hash["info"]["email"]
    if authentication.user
      user = authentication.user 
      authentication.update_token(auth_hash)
    	notice = "Successful sign in!"
    elsif User.find_by_email(email)
    	user = User.find_by_email(email)
    	user.authentications << authentication
    	notice = "Successful sign in!"
    else
      user = User.create_with_auth_and_hash(authentication, auth_hash)
      notice = "Successful sign up and you are now signed in!"
    end
    sign_in(user)
    redirect_to root_path, notice:notice
  end

end
