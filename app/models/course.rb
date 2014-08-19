class Course < ActiveRecord::Base

	belongs_to 				:users
	has_and_belongs_to_many 	:study_materials, :through => :course_materials

	attr_accessible :description, :name

end
