class PagesController < ApplicationController
  def home
  	@title = "Home"
    @user = User.new
    if user_signed_in? 
      @title = "Welcome " + current_user.name
    end 
  end

  def contact
  	@title = "Contact"
  end

  def about
  	@title = "About"
  end

  def help
  	@title = "Help"
  end
  
end