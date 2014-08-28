class PagesController < ApplicationController
  def home
  	@title = "Home"
    @user = User.new
    if user_signed_in? 
      @title = "Welcome " + current_user.name
      @dashboard_tab = true
      render 'users/dashboard'
    end 
  end

  def contact
  	@title = "Contact"
  end

  
end