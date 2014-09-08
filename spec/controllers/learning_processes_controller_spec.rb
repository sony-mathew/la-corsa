require 'spec_helper'

describe LearningProcessesController do
	
	describe "access control" do

		it "should require signin for any action" do 
			get :index
			response.should redirect_to(new_user_session_path)
		end

		describe " Signed in users " do
			before(:each) do
				@user = FactoryGirl.create(:user)
				sign_in @user
				@course = FactoryGirl.create(:course)
			end

			it "should redirect to home page if simply gave a get request for index" do
				get :index
				response.should redirect_to(root_path)
			end

			describe " Enroll Me " do

				describe "success" do
					it "should enroll themselves" do
						xhr :get, :enroll_me, :course_id => @course.id
						response.body.should match(/success/i)
					end
				end

				describe " failure " do
					it "should not enroll themselves with invalid course_id" do
						xhr :get, :enroll_me, :course_id => 500
						response.body.should match(/not found/i)
					end

					it "should not enroll if already enrolled" do
						xhr :get, :enroll_me, :course_id => @course.id
						xhr :get, :enroll_me, :course_id => @course.id
						response.body.should match(/already enrolled/i)
					end
				end
			end

			describe " Suggest Course" do
				describe "success" do
					it "should enroll suggested ones" do
						@user2 = FactoryGirl.create(:user)
						xhr :get, :suggest, :email => @user2.email, :course_id => @course.id
						response.body.should match(/success/i)
					end
				end

				describe "failure" do
					it "should not enroll suggested ones if already enrolled" do
						@user2 = FactoryGirl.create(:user)
						xhr :get, :suggest, :email => @user2.email, :course_id => @course.id
						xhr :get, :suggest, :email => @user2.email, :course_id => @course.id
						response.body.should match(/already enrolled/i)
					end

					it "should notify if user not in the database" do
						xhr :get, :suggest, :email => "cool@hdjhfj.com", :course_id => @course.id
						response.body.should match(/Email ID not registered/i)
					end
				end
			end

			describe "drop course" do
				before(:each)  do
					xhr :get, :enroll_me, :course_id => @course.id
					xhr :get, :drop_course, :lp_id => @user.occurences_as_student.first.id
				end
				it "should be success if dropped" do
					response.body.should match(/success/i)
				end
				it "should be failure if already dropped" do
					xhr :get, :drop_course, :lp_id => @user.occurences_as_student.first.id
					response.body.should match(/error/i)
				end
			end

			describe "activate course" do
				before(:each)  do
					xhr :get, :enroll_me, :course_id => @course.id
					xhr :get, :activate_course, :lp_id => @user.occurences_as_student.first.id
				end
				it "should be success if activated" do
					xhr :get, :drop_course, :lp_id => @user.occurences_as_student.first.id
					xhr :get, :activate_course, :lp_id => @user.occurences_as_student.first.id
					response.body.should match(/success/i)
				end
				it "should be failure if already activated" do
					xhr :get, :activate_course, :lp_id => @user.occurences_as_student.first.id
					response.body.should match(/error/i)
				end
			end

			describe "finished material" do
				before(:each)  do
					xhr :get, :enroll_me, :course_id => @course.id
					xhr :get, :finished_material, :lp_id => @user.occurences_as_student.first.id
				end

				it "should be a success if actually there is material to finish" do
					response.body.should match(/success/i)
				end

				it "should be a failure if already completed" do
					xhr :get, :finished_material, :lp_id => @user.occurences_as_student.first.id
					xhr :get, :finished_material, :lp_id => @user.occurences_as_student.first.id
					response.body.should match(/error/i)
				end
			end

			describe "rate course" do
				before(:each) do
					xhr :get, :enroll_me, :course_id => @course.id
					xhr :get, :finished_material, :lp_id => @user.occurences_as_student.first.id
				end

				it "should be succes and rate if course completed" do
					xhr :get, :finished_material, :lp_id => @user.occurences_as_student.first.id
					xhr :get, :rate_course, :rating => 4, :lp_id => @user.occurences_as_student.first.id
					response.body.should match(/succes/i)
				end
				it "should be failure and should not rate if course not completed" do
					xhr :get, :rate_course, :rating => 4, :lp_id => @user.occurences_as_student.first.id
					response.body.should match(/error/i)
				end
			end


			describe "list students" do
				before(:each) do
					@user2 = FactoryGirl.create(:user)
				end

				it "success should list all students" do
					xhr :get, :suggest, :email => @user2.email, :course_id => @course.id
					get :students
					controller.instance_variable_get("@students").count.should eq(1)
				end
				it "failure should not show students" do
					get :students
					controller.instance_variable_get("@students").count.should eq(0)
				end
			end

			describe "list courses" do
				before(:each) do
					xhr :get, :enroll_me, :course_id => @course.id
				end

				describe "current courses" do
					describe "success" do
						it "should list all the current courses" do
							get :courses, :status => :pursuing
							controller.instance_variable_get("@courses").count.should eq(1)
						end
					end	

					describe "failure" do
						it "should not list any current courses" do
							xhr :get, :drop_course, :lp_id => @user.occurences_as_student.first.id
							get :courses, :status => :pursuing
							controller.instance_variable_get("@courses").count.should eq(0)
						end
					end
				end

				describe "dropped courses" do
					describe "success" do
						it "should list all the dropped courses" do
							xhr :get, :drop_course, :lp_id => @user.occurences_as_student.first.id
							get :courses, :status => :dropped
							controller.instance_variable_get("@courses").count.should eq(1)
						end
					end	

					describe "failure" do
						it "should not list any dropped courses" do
							get :courses, :status => :dropped
							controller.instance_variable_get("@courses").count.should eq(0)
						end
					end
				end

				describe "completed courses" do
					describe "success" do
						it "should list all the completed courses" do
							xhr :get, :finished_material, :lp_id => @user.occurences_as_student.first.id
							xhr :get, :finished_material, :lp_id => @user.occurences_as_student.first.id
							get :courses, :status => :completed
							controller.instance_variable_get("@courses").count.should eq(1)
						end
					end	

					describe "failure" do
						it "should not list any completed courses" do
							get :courses, :status => :completed
							controller.instance_variable_get("@courses").count.should eq(0)
						end
					end
				end

			end
		end
	end

	
end