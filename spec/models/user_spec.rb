require 'spec_helper'

describe User do

	before { @user = User.new(name: "Eg user", email: "user@eg.com", password: "foobar11", password_confirmation: "foobar11", nickname: "nick", dob: "04/05/2014") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:name) }
	it { should respond_to(:dob) }
	it { should respond_to(:nickname) }
	it { @user.should be_valid}

	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
										 foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_USER@f.b.org frstlst@foo.jp ab@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 7 }
		it { should be_invalid }
	end

	describe "course associations" do

		let!(:user) do
			FactoryGirl.create(:user)
		end

		let!(:older_course) do 
			FactoryGirl.create(:course, :user_id => user.id, created_at: 1.day.ago)
		end
		let!(:newer_course) do
			FactoryGirl.create(:course, :user_id => user.id, created_at: 1.hour.ago)
		end
				
		it "should have the right courses in the right order" do
			user.courses.should =~ [newer_course, older_course]
		end

		it "should destroy associated courses" do
			courses = user.courses.dup
			user.destroy
			courses.should_not be_empty
			courses.each do |course|
				Course.find_by_id(course.id).should be_nil
			end
		end
	end

	describe "study matererial associations" do
		
		let!(:user) do
			FactoryGirl.create(:user)
		end
		let!(:sm) do 
			FactoryGirl.create(:study_material, user: user, created_at: 1.day.ago)
		end

		it "should destroy associated study matererials" do
			study_materials = user.study_materials.dup
			user.destroy
			study_materials.each do |study_material|
				StudyMaterial.find_by_id(study_material.id).should be_nil
			end
		end
	end

	describe "student-mentor associations" do
		before(:each) do 
			@user = FactoryGirl.create(:user)
		@course = FactoryGirl.create(:course)
			@user2 = FactoryGirl.create(:user)
			@lp = @course.learning_processes.new({:student => @user2, :mentor => @user})
			@lp.save!
		end

		it "should destroy all the course related students records" do
			lp = @user.occurences_as_mentor.dup
			@user.destroy
			lp.should_not be_empty
			lp.each do |lpp|
				LearningProcess.find_by_id(lpp.id).should be_nil
			end
		end

	
		it "should destroy all the course related mentor records" do
			lp = @user2.occurences_as_student.dup
			@user2.destroy
			lp.should_not be_empty
			lp.each do |lpp|
				LearningProcess.find_by_id(lpp.id).should be_nil
			end
		end  	

	end
end