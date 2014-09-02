class ApplicationController < ActionController::Base
  	protect_from_forgery
  
  	def authenticate_user
		redirect_to new_user_session_path unless user_signed_in? 
	end

	def debug(temp_var)
		p  '#'*120
		p temp_var
		p  '#'*120
	end
end
