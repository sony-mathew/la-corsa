class StudyMaterial < ActiveRecord::Base

	belongs_to :users
	has_and_belongs_to_many :courses, :through => :course_materials

	attr_accessible :description, :title
	
end
