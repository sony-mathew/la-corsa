class Course < ActiveRecord::Base

	belongs_to 	:user
	has_many	:course_materials
	has_many 	:study_materials, :through => :course_materials
	has_many	:learning_processes

	validates :name, :presence => true, :length => { :minimum => 4, :maximum => 70}, :uniqueness 	=> { :case_sensitive => false }
	validates :description, :presence => true, :length => { :minimum => 20, :maximum => 1000}

	attr_accessible :description, :name, :course_materials_count




end
