require 'spec_helper'

describe "Users" do
	
	describe "signup" do 
		
		describe "failure" do
			
			it "should not make a new user" do 
				lambda do
					visit new_user_registration_path
					fill_in :user_name,:with => ""
		        	fill_in "Email",:with => " "
		        	fill_in "Password",	:with => " "
		        	fill_in "Password Confirmation", :with => " "
		        	click_button
					response.should have_selector("a", :href => new_user_session_path,:content => "Sign in")
		        end.should_not change(User, :count)
			end 

		end

		describe "success" do
			it "should make a new user" do 
				lambda do
					visit new_user_registration_path
					fill_in "Name", :with => "Example User"
					fill_in "Email", :with => "user@example.com"
					fill_in "Password", :with => "foobar11"
					fill_in "Password Confirmation", :with => "foobar11"
					fill_in :user_nickname, :with => "cool"
					fill_in :user_dob, :with => "25/05/1992"
					click_button
					response.should have_selector("a", :href => destroy_user_session_path, :content => "Sign Out")
					response.should render_template('users/dashboard') 
				end.should change(User, :count).by(1)
			end 
		end

	end

	describe "sign in/out" do

		describe "failure" do
			it "should not sign a user in" do
        		visit root_path
        		fill_in :email,    :with => ""
        		fill_in :password, :with => ""
        		click_button
				response.should have_selector("h2", :content => "Sign in")
			end 
		end

		describe "success" do
			it "should sign a user in and out" do
        		user = FactoryGirl.create(:user)
        		visit new_user_session_path
        		fill_in :email,    :with => user.email
        		fill_in :password, :with => user.password
        		click_button
        		controller.should be_signed_in
        		click_link "Sign Out"
        		controller.should_not be_signed_in
        	end
        end
    end
    

end
