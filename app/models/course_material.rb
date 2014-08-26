class CourseMaterial < ActiveRecord::Base
	
	belongs_to 	:study_material
	belongs_to 	:course

	default_scope :order => 'course_materials.order ASC'

	validates :course_id, :presence => true
	validates :study_material_id, :presence => true
	validates :order, :presence => true

end