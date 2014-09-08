require 'spec_helper'

describe StudyMaterial do

	before(:each) do 
		@user = FactoryGirl.create(:user)
		@sm = FactoryGirl.create(:study_material, :user_id => @user.id, created_at: 1.day.ago)
		@course =  FactoryGirl.create(:course, :material_ids => [@sm.id]) 
	end

	before { @study_material = @user.study_materials.build(:title => 'sdaghj', :description => "kadskjfhdkjfhsdkj", :link => "dhfj.com") }

	subject { @study_material }

	it { should respond_to(:title) }
	it { should respond_to(:description) }
	it { should respond_to(:link) }
	it { should respond_to(:user) }
	it { should respond_to(:user_id) }

	its(:user) { should == @user }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				StudyMaterial.new(user_id: @user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end    
	end

	describe "when title is not present" do
		before { @study_material.title = nil }
		it { should_not be_valid }
	end

	describe "when study_material_id is not present" do
		before { @study_material.description = nil }
		it { should_not be_valid }
	end

	describe "when order is not present" do
		before { @study_material.link = nil }
		it { should_not be_valid }
	end

	describe "course material associations" do

		it "should destroy associated course materials" do
			@cms = @sm.course_materials.dup
			@sm.destroy
			@cms.should_not be_empty
			@cms.each do |coursematerial|
				CourseMaterial.find_by_id(coursematerial.id).should be_nil
			end
		end
	end

end