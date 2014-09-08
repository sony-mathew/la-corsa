require 'spec_helper' 
	
	describe "LayoutLinks" do
	
		it "should have a Home page at '/'" do get '/'
    		response.should have_selector('title', :content => "La Corsa | Home")
		end

		it "should have an About page at '/about'" do
			get '/about'
			response.should have_selector('title', :content => "La Corsa | About")
		end

		it "should have a Sign Up page at '/signup'" do
			get '/users/sign_up'
			response.should have_selector('h2', :content => "Sign up")
		end 


		describe "when not signed in" do
			it "should have a signin link" do
				visit root_path
				response.should have_selector("a", :href => new_user_session_path,:content => "Sign in")
			end 
		end

		describe "when signed in" do
			
			before(:each) do
				@user = FactoryGirl.create(:user)
				visit new_user_session_path
				fill_in :email, :with => @user.email 
				fill_in :password, :with => @user.password 
				click_button
			end

			it "should have a signout link" do
				visit root_path
				response.should have_selector("a", :href => destroy_user_session_path, :content => "Sign Out")
			end

    		it "should have a open courses link" do
    			visit root_path
			    response.should have_selector("a", :href => "/courses/filter/open",:content => "Open Courses")
			end

    		it "should have a learn link" do
    			visit root_path
			    response.should have_selector("a", :href => "/courses/enrolled/current",:content => " Learn ")
			end

    		it "should have a teach link" do
    			visit root_path
			    response.should have_selector("a", :href => "/students",:content => "Teach")
			end
			
		end
	end
