require 'spec_helper'

describe CoursesController do 

	render_views

	describe "Access control : " do
		describe "Not signed in user " do
			it "should be denied access to 'create'" do 
				post :create
				response.should redirect_to(new_user_session_path)
			end
			it "should be denied access to 'destroy'" do 
				delete :destroy, :id => 1 
				response.should redirect_to(new_user_session_path)
			end 
		end

		describe "Signed in" do

			describe "Correct user" do
				before(:each) do
					@user = FactoryGirl.create(:user)
					sign_in @user
				end	

				it "should be shown page to add new course" do
					get :new
					response.should render_template("new")
				end

				describe "doing POST 'create'" do
					before(:each) do
						@attr = { :name=> "", :description => "", :material_ids => [] }
					end

					describe "failure" do
						it "should not create a course" do 
							lambda do
								post :create, :course => @attr 
							end.should_not change(Course, :count)
						end

						it "should render the add new course page" do
							post :create, :course => @attr 
							response.should redirect_to(new_course_path)
						end
					end	

					describe "success" do
						before(:each) do
							@sm = FactoryGirl.create("study_material")
							@attr = { :name=> "qwerty", :description => "khgfbkj bkjfb kjbfkj bkjdsfb kjs", :material_ids => [@sm.id] }
						end
						it "should create a course" do 
							lambda do
			          			post :create, :course => @attr
							end.should change(Course, :count).by(1)
						end
						it "should redirect to add new course page" do 
							post :create, :course => @attr 
							response.should redirect_to(new_course_path)
						end
						it "should have a flash message success" do
							post :create, :course => @attr 
							flash[:success].should =~ /saved successfully/i
						end
					end
				end

				describe "GET #edit" do
					before :each do
						@course = FactoryGirl.create(:course, :user => @user)
					end
				  	it "should render the course edit template" do
				  		get :edit, id: @course
				  		controller.should render_template("new")
					end
				end

				describe "doing PUT 'update'" do
					before(:each) do
						@course = FactoryGirl.create(:course, :user_id => @user.id)
					end

					describe "failure" do
						before(:each) do
							@cs = FactoryGirl.attributes_for(:course)
							@cs[:name] = nil
							put :update, id: @course, :course => @cs
						end

						it "should not update the course" do
							@course.reload
							@course.name.should_not eq(nil)
						end

						it "should give an error message of invalid record" do
							flash[:error].should =~ /not update/i
						end

						it "should give an error message of not sufficeint study materials" do
							@cs[:material_ids] = []
							put :update, id: @course, :course => @cs
							flash[:error].should =~ /we could not save your course/i
						end

						it "should show the courses list page" do
							response.should redirect_to(courses_path)
						end
					end
						
					describe "success" do
						before(:each) do
							put :update, id: @course, course: FactoryGirl.attributes_for(:course)
						end

						it "should update the course" do
							@course.reload
							@course.name.should eq(@course.name)
						end

						it "should show the updated success message" do
							flash[:success].should =~ /successfully updated the course/i
						end

						it "should list all the study materials itself" do
							response.should redirect_to(courses_path)
						end
					end	
				end

				describe "DELETE 'destroy'" do
					before(:each) do
						@course = FactoryGirl.create(:course, :user_id => @user.id)
					end
					
					describe "success if no one is taking the course" do
						it "should destroy the the course" do 
							lambda do
								delete :destroy, :id => @course
							end.should change(Course, :count).by(-1)
						end
					end 

					describe "failure if someone is taking the course" do
						it "should not destroy the course" do
						end
					end
				end

				describe "GET 'index'" do
					it "should show user_study_materials" do
						get :index
						response.should render_template("index")
					end
					it "should show all study materials filter all" do
						get :index, :courses_filter => "all"
						response.should render_template("index")
					end
				end	

				describe "GET 'show'" do
					it "should show the specified Course if it exists" do
						@course = FactoryGirl.create(:course, :user_id => @user.id)
						get :show, :id => @course
						response.should render_template("show")
					end

					it "should give the error message if the id does not exist" do
						get :show, :id => 999
						flash[:error].should match(/Could not find/i)
					end
				end

			end

			describe "Wrong user" do
				before(:each) do
					@user = FactoryGirl.create(:user)
					wrong_user = FactoryGirl.create(:user)
					sign_in wrong_user
					@course = FactoryGirl.create(:course, :user => @user)
				end
				
				describe "GET #edit" do
				  	it "should not render the edit page" do
				  		get :edit, id: @course
				  		controller.should redirect_to(courses_path)
					end
				end

				describe "doing PUT 'update'" do
					it "should not update the course and display a error message" do
						put :update, id: @course, course: FactoryGirl.attributes_for(:course)
						flash[:error].should redirect_to(courses_path)
					end
				end

				describe "DELETE 'destroy'"	do
					it "should not destroy the course" do 
						lambda do
							delete :destroy, :id => @course
						end.should_not change(Course, :count).by(-1)
					end 
				end
			end
		end
	end
end