require 'spec_helper'
describe CourseMaterial do

	let(:user) { FactoryGirl.create(:user) }
	let(:course) { FactoryGirl.create(:course) }
	let!(:sm) do 
			FactoryGirl.create(:study_material, :user_id => user.id, created_at: 1.day.ago)
		end

	before { @course_material = course.course_materials.build(:order => 1, :study_material_id => sm.id) }

	subject { @course_material }

	it { should respond_to(:course) }
	it { should respond_to(:course_id) }
	it { should respond_to(:order) }
	it { should respond_to(:study_material) }
	it { should respond_to(:study_material_id) }

	describe "when course_id is not present" do
		before { @course_material.course_id = nil }
		it { should_not be_valid }
	end

	describe "when study_material_id is not present" do
		before { @course_material.study_material_id = nil }
		it { should_not be_valid }
	end

	describe "when order is not present" do
		before { @course_material.order = nil }
		it { should_not be_valid }
	end
end