class Course < ActiveRecord::Base

	belongs_to 	:user
	has_many	:course_materials, :dependent => :destroy
	has_many 	:study_materials, :through => :course_materials
	has_many	:learning_processes

	validates :name, :presence => true, :length => { :minimum => 4, :maximum => 70}, :uniqueness 	=> { :case_sensitive => false }
	validates :description, :presence => true, :length => { :minimum => 20, :maximum => 1000}
	

	attr_accessible :description, :name, :course_materials_count, :material_ids
	attr_accessor :material_ids

	before_save :add_study_materials_to_course , :unless => [:rating_changed?, :rating_user_count_changed?]
	before_update :update_study_materials_of_course, :unless => [:rating_changed?, :rating_user_count_changed?]

	def add_study_materials_to_course
		study_material_ids = self.material_ids.split(',').collect{|str| str.to_i}
		self.course_materials_count = study_material_ids.count
		study_material_ids.each_with_index do | id, index |
			if id > 0
				course_material = self.course_materials.new()
				course_material.order, course_material.study_material_id = index + 1, id
				course_material.save
			end
		end
	end

	def update_study_materials_of_course
		self.course_materials.destroy_all
		self.learning_processes.update_all("`last_material` = 0")
		add_study_materials_to_course
	end

	def is_sufficient_materials?
		material_ids.split(',').collect{|str| str.to_i}.count > 0
	end

	def rate!(user_rating)
		self.rating = ( rating * course.rating_user_count + user_rating )/rating_user_count
		self.rating_user_count += 1
		save!
	end
end
