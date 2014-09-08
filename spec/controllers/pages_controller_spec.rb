require 'spec_helper'

describe PagesController do
	render_views

	describe "GET 'home'" do
	it "should be successful" do
		{ :get => "/" }.should route_to(:controller => "pages", :action => "home")
		response.should be_success
	end

	it "should have the right title" do
		get :home
		response.should have_selector("title",
					:content => "La Corsa | Home")
	end

	describe "when not signed in" do
		
		before(:each) do 
			get :home
		end

		it "should be successful" do 
			response.should be_success
		end

		it "should have the right title" do 
			response.should have_selector("title",:content => "La Corsa | Home")
		end
	end


	describe "when signed in" do
		
		before(:each) do
			@user = FactoryGirl.create(:user)
			sign_in @user
			get :home
		end

		it "should be be successful" do
			response.should be_success
		end

		it "should render dashboard view" do
			response.should render_template('users/dashboard')
		end

		it "should have the welcome message" do
			response.should have_selector("h1", :content => "Hello, #{@user.name.capitalize}")
		end
	end

	end

	describe "GET 'about'" do
		it "should be successful" do
			get 'about'
			response.should be_success
		end

		it "should have the right title" do
			get 'about'
			response.should have_selector("title", 
			:content => "La Corsa | About")
		end
	end

end
