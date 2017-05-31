module SessionsHelper
	def current_user	# ActiveRecord::RecordNotFound in StaticController#home 
		begin
			if session[:user_id] 
				@current_user ||= User.find(session[:user_id])
			elsif cookies.signed[:user_id]
				@current_user ||= User.find(cookies.signed[:user_id])
			end

		# Basically trying to rescue the case when omniauth successful log in but user was not saved (did not save despite using save(validate:false)), which would result in session being stored but current_user method unable to find user (line 5: User.find(session[:user_id] gives error). So when view page calls current_user method user is unable to visit site forever (for as long as session is alive) because current_user method is throwing error. Temporary solution is to clear cookies.
		# Unable to replicate the error ever since.

		rescue ActiveRecord::RecordNotFound => e 
			session[:user_id] = nil
			cookies.signed[:user_id] = nil
			return nil
		end
	end

	def current_user=(user)
		@current_user = user
	end

	def logged_in?
		!current_user.nil?
	end

	def sign_in(user)
		cookies.signed[:email] = {value:user.email, expires:14.days.from_now}
		session[:user_id] = user.id 
	end

	def sign_in_with_cookies(user)
		cookies.signed[:user_id] = {value:user.id, expires:14.days.from_now}
		sign_in(user)
	end

	def sign_out
		if logged_in?
			current_user.update(remember_token:false)
			current_user = session[:user_id] = nil
			cookies.delete(:user_id)
		end
	end

end
