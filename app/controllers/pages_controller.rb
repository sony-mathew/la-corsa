class PagesController < ApplicationController

  before_filter :set_tab

  def home
  	@title = "Home"
    if user_signed_in? 
      @title = "Welcome " + current_user.name
      render 'users/dashboard'
    end 
  end

  def contact
  	@title = "Contact"
  end

  def set_tab
    @main_tab = :dashboard if user_signed_in?
  end

  
end