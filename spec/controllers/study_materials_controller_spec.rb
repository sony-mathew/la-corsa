require 'spec_helper'

describe StudyMaterialsController do 

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

				it "should be shown page to study material" do
					get :new
					response.should render_template('study_materials/new')
				end

				describe "doing POST 'create'" do
					before(:each) do
						@attr = { :title=> "", :description => "", :link => "" }
					end

					describe "failure" do
						it "should not create a study_material" do 
							lambda do
								post :create, :study_material => @attr 
							end.should_not change(StudyMaterial, :count)
						end

						it "should render the add new study material page" do
							post :create, :study_material => @attr 
							response.should redirect_to(new_study_material_path)
						end
					end	

					describe "success" do
						before(:each) do
							@attr = { :title=> "sample cool testing ", :description => "khgfbkj bkjfb kjbfkj bkjdsfb kjsfb kjsfb kjs bksjdfb fkj", :link => "http://www.google.com" }
						end
						it "should create a study_material" do 
							lambda do
			          			post :create, :study_material => @attr
							end.should change(StudyMaterial, :count).by(1)
						end
						it "should redirect to add new study material page" do 
							post :create, :study_material => @attr 
							response.should redirect_to(new_study_material_path)
						end
						it "should have a flash message success" do
							post :create, :study_material => @attr 
							flash[:success].should =~ /Study Material saved successfully/i
						end
					end
				end

				describe "GET #edit" do
					before :each do
						@study_material = FactoryGirl.create(:study_material, :user => @user)
					end
				  	it "should render the edit template" do
				  		get :edit, id: @study_material
				  		controller.should render_template("new")
					end
				end

				describe "doing PUT 'update'" do
					before(:each) do
						@study_material = FactoryGirl.create(:study_material, :user_id => @user.id)
					end

					describe "failure" do
						before(:each) do
							@sm = FactoryGirl.attributes_for(:study_material)
							@sm[:title] = nil
							put :update, id: @study_material.id, :study_material => @sm
						end

						it "should not update the record" do
							@study_material.reload
							@study_material.title.should_not eq(nil)
						end

						it "should give an error message" do
							flash[:error].should =~ /not update/i
						end

						it "should show the update page itself" do
							response.should render_template('study_materials/new')
						end
					end
						
					describe "success" do
						before(:each) do
							put :update, id: @study_material, study_material: FactoryGirl.attributes_for(:study_material)
						end

						it "should update the record" do
							@study_material.reload
							@study_material.title.should eq(@study_material.title)
						end

						it "should update the record" do
							flash[:success].should =~ /Study Material updated/i
						end

						it "should list all the study materials itself" do
							response.should redirect_to(study_materials_path)
						end
					end	
				end

				describe "DELETE 'destroy'" do
					before(:each) do
						@study_material = FactoryGirl.create(:study_material, :user_id => @user.id)
					end
			
					it "should destroy the study material" do 
						lambda do
							delete :destroy, :id => @study_material
						end.should change(StudyMaterial, :count).by(-1)
					end 

					it "should not destroy the study material if it's part of some other course" do
						FactoryGirl.create(:course, :material_ids => [@study_material.id])
						lambda do
							delete :destroy, :id => @study_material
						end.should_not change(StudyMaterial, :count).by(-1)
					end
				end

				describe "GET 'index'" do
					it "should show user_study_materials" do
						get :index
						response.should render_template("index")
					end
					it "should show all study materials filter all" do
						get :index, :materials_filter => "all"
						response.should render_template("index")
					end
				end	

				describe "GET 'show'" do
					it "should show the specified Study Material if it exists" do
						@study_material = FactoryGirl.create(:study_material, :user_id => @user.id)
						get :show, :id => @study_material
						response.should render_template("show")
					end

					it "should give the error message if the id does not exist" do
						get :show, :id => 999
						flash[:error].should match(/Could not find/i)
					end
				end

				describe "GET 'Search'" do
					it "should give a result for a valid query" do
						@study_material = FactoryGirl.create(:study_material, :user_id => @user.id)
						xhr :get, :search, :search => "something"
						response.body.should match(/something/i)
					end
					it "should give a blank response for a invalid query" do
						xhr :get, :search, :search => "something"
						response.body.should == "[]" 
					end
				end
			end

			describe "Wrong user" do
				before(:each) do
					@user = FactoryGirl.create(:user)
					wrong_user = FactoryGirl.create(:user)
					sign_in wrong_user
					@study_material = FactoryGirl.create(:study_material, :user => @user)
				end
				
				describe "GET #edit" do
				  	it "should not render the edit page" do
				  		get :edit, id: @study_material
				  		controller.should redirect_to(study_materials_path)
					end
				end

				describe "doing PUT 'update'" do
					it "should not update the material" do
						put :update, id: @study_material, study_material: FactoryGirl.attributes_for(:study_material)
						flash[:error].should =~ /Could not edit/i
					end
				end

				describe "DELETE 'destroy'"	do
					it "should not destroy the study material" do 
						lambda do
							delete :destroy, :id => @study_material
						end.should_not change(StudyMaterial, :count).by(-1)
					end 
				end
			end
		end
	end
end

