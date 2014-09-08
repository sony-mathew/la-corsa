require 'spec_helper'
describe Course do

	let(:user) { FactoryGirl.create(:user) }
	before { @course = user.courses.build(name: "sample name of course", description: "sample description of the course", material_ids: ["4", "2"] ) }

	subject { @course }

	it { should respond_to(:name) }
	it { should respond_to(:description) }
	it { should respond_to(:material_ids) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }

	its(:user) { should == user }
	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				Course.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end 
		it "should not allow access to rating" do
			expect do
				Course.new(rating: 0.5)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end    
		it "should not allow access to rating_user_count" do
			expect do
				Course.new(rating_user_count: 14)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
		it "should not allow access to course_completed_count" do
			expect do
				Course.new(course_completed_count: 14)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end 
		it "should not allow access to current_users_count" do
			expect do
				Course.new(current_users_count: 14)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end    
	end

	describe "when name is not present" do
		before { @course.name = nil }
		it { should_not be_valid }
	end

	describe "when name is less than requierd length" do
		before { @course.name = "we" }
		it { should_not be_valid }
	end

	describe "when description is not present" do
		before { @course.description = nil }
		it { should_not be_valid }
	end

	describe "when material_ids is not present" do
		before { @course.material_ids = nil }
		it { should_not be_valid }
	end


	describe "study material associations" do

		let!(:sm) do 
			FactoryGirl.create(:study_material, :user_id => user.id, created_at: 1.day.ago)
		end
		let!(:course) do
			FactoryGirl.create(:course, :user_id => user.id, :material_ids => [sm.id])
		end

		it "should not destroy associated study material" do
			studymaterials = course.study_materials.dup
			course.destroy
			studymaterials.should_not be_empty
			studymaterials.each do |studymaterial|
				StudyMaterial.find_by_id(studymaterial.id).should_not be_nil
			end
		end
	end


	describe "course material associations" do

		let!(:sm1) do 
			FactoryGirl.create(:study_material, :user_id => user.id, :title => "diff title 1", :link => "dfc.com")
		end
		let!(:sm2) do 
			FactoryGirl.create(:study_material, :user_id => user.id, :title => "diff title 2", :link => "ghjou.com")
		end
		let!(:course) do
			FactoryGirl.create(:course, :user_id => user.id, :material_ids => [sm1.id, sm2.id])
		end

		it "should have the right course materials in the right order" do
			course.study_materials.should =~ [sm1, sm2]
		end

		it "should destroy associated course materials" do
			coursematerials = course.course_materials.dup
			course.destroy
			coursematerials.should_not be_empty
			coursematerials.each do |coursematerial|
				CourseMaterial.find_by_id(coursematerial.id).should be_nil
			end
		end
	end


	describe "learning process associations" do
		let!(:sm1) do 
			FactoryGirl.create(:study_material, :user_id => user.id, :title => "diff title 1", :link => "dfc.com")
		end
		let!(:sm2) do 
			FactoryGirl.create(:study_material, :user_id => user.id, :title => "diff title 2", :link => "ghjou.com")
		end
		let!(:course) do
			FactoryGirl.create(:course, :user_id => user.id, :material_ids => [sm1.id, sm2.id])
		end
		let!(:user2) do
			FactoryGirl.create(:user)
		end
		let!(:lp) do
			course.learning_processes.new({:student => user2, :mentor => user})
		end
		it "should destroy associated learning learning_processes" do
			lps = course.learning_processes.dup
			course.destroy
			lps.should_not be_empty
			lps.each do |lp|
				LearningProcess.find_by_id(lp.id).should be_nil
			end
		end

	end

end