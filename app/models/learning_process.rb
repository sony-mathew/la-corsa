class LearningProcess < ActiveRecord::Base

	belongs_to :mentor , :class_name => "User", :foreign_key => "mentor"
	belongs_to :student, :class_name => "User", :foreign_key => "student"


	attr_accessible :mentor, :student

end
