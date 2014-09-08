require 'spec_helper'

describe LearningProcess do

	let(:user1) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user) }
	let!(:sm) do 
			FactoryGirl.create(:study_material, :user_id => user1.id, created_at: 1.day.ago)
		end
	let(:course) { FactoryGirl.create(:course, :material_ids => [sm.id]) }

	before { @lp = course.learning_processes.build(:mentor => user1, :student => user2 ) }

	subject { @lp }

	it { should respond_to(:mentor) }
	it { should respond_to(:student) }
	it { should respond_to(:course) }
	it { should respond_to(:course_id) }

	describe "accessible attributes" do
		it "should not allow access to course_id" do
			expect do
				LearningProcess.new(course_id: course.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end  
		it "should not allow access to status" do
			expect do
				LearningProcess.new(status: 2)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
		it "should not allow access to rating flag" do
			expect do
				LearningProcess.new(rated: true)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end    
	end

	describe "when mentor is not present" do
		before { @lp.mentor = nil }
		it { should_not be_valid }
	end

	describe "when student is not present" do
		before { @lp.student = nil }
		it { should_not be_valid }
	end


	describe "when status is complete" do
		before { @lp.status = 0 }
		it { @lp.send("complete?").should be_true }
	end


	describe "when status is dropped" do
		before { @lp.status = 1 }
		it { @lp.send("dropped?").should be_true }
	end


	describe "when status is pursuing" do
		before { @lp.status = 0 }
		it { @lp.send("pursuing?").should be_false }
	end

	describe "when status is suggested" do
		before { @lp.status = 0 }
		it { @lp.send("suggested?").should be_false }
	end


	describe "when status is suggested" do
		before { @lp.status = 0 }
		it { @lp.send("self_student?").should be_true }
	end


	describe "when status is suggested" do
		before { @lp.status = 0 }
		it { @lp.send("status_name").should == :Completed }
	end
		
end
