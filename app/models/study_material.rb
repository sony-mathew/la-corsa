class StudyMaterial < ActiveRecord::Base

	belongs_to 	:user
	has_many	:course_materials
	has_many 	:courses, :through => :course_materials

	attr_accessible :description, :title, :link

	validates :description, :presence => true, :length => { :maximum => 999, :minimum => 10 }
  	validates :user_id, :presence => true
  	validates :title, :presence => true, :length => { :maximum => 255, :minimum => 4 }, :uniqueness 	=> { :case_sensitive => false }
  	validates :link, :presence => true, :length => { :maximum => 255, :minimum => 5 }, :uniqueness 	=> { :case_sensitive => true }

  	#default_scope :order => 'study_materials.created_at DESC'

end
