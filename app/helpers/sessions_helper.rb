module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
		# puts "HAHA IN LOG_IN"
		# puts session[:user_id]
		# # puts user.id, user.email, user.password
		# puts "HAHA OUT LOG_IN"
		# @current_user = user
	end

	def current_user
		if @current_user.nil?
		  @current_user = User.find_by(id: session[:user_id])
		else
		  @current_user
		end		
		# puts "CURRENT_USER IN",session[:user_id],"CURRENT_USER OUT"
		return @current_user
	end

	def logged_in?
		if @current_user==nil
			false
		else
			true
		end
	end

end
