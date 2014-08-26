class LearningProcess < ActiveRecord::Base

	belongs_to :mentor , :class_name => "User", :foreign_key => "mentor"
	belongs_to :student, :class_name => "User", :foreign_key => "student"
	belongs_to :course


	attr_accessible :mentor, :student

	validates :mentor, :presence => true
	validates :student, :presence => true
	validates :course_id, :presence => true

	default_scope :order => 'learning_processes.created_at DESC'

end
