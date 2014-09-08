class Course < ActiveRecord::Base

	belongs_to 	:user
	has_many	:course_materials, :dependent => :destroy
	has_many 	:study_materials, :through => :course_materials
	has_many	:learning_processes, :dependent => :destroy

	validates :name, :presence => true, :length => { :minimum => 4, :maximum => 70}, :uniqueness 	=> { :case_sensitive => false }
	validates :description, :presence => true, :length => { :minimum => 10, :maximum => 1000}
	validates :material_ids, :presence => true
	

	attr_accessible :description, :name, :course_materials_count, :material_ids
	attr_accessor :material_ids

	default_scope order('created_at DESC')

	before_save :update_count, :unless => [:rating_changed?, :rating_user_count_changed?]
	after_save :add_study_materials , :unless => [:rating_changed?, :rating_user_count_changed?]
	after_update :update_study_materials, :unless => [:rating_changed?, :rating_user_count_changed?]

	def add_study_materials
		material_ids.each_with_index do | id, index |
			next unless valid_study_material?(id.to_i)
			self.course_materials.create( :order => (index+1), :study_material_id => id.to_i)
		end
	end

	def update_count
		self.course_materials_count = material_ids.count
	end

	def update_study_materials
		self.course_materials.destroy_all
		self.learning_processes.update_all(:last_material => 0)
	end

	def sufficient_materials?
		material_ids.count > 0
	end

	def rate!(user_rating)
		self.rating = ( rating * rating_user_count + user_rating )/(rating_user_count+1)
		self.rating_user_count += 1
		save(validate: false)
	end

	def valid_study_material?(id)
		StudyMaterial.find_by_id(id) ? true : false
	end
end
