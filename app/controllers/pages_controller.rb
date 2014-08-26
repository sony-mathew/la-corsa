class PagesController < ApplicationController
  def home
  	@title = "Home"
    @user = User.new
    if user_signed_in? 
      @title = "Welcome " + current_user.name
      @nav_active = 'c'
      render 'users/dashboard'
    end 
  end

  def contact
  	@title = "Contact"
  end

  
end