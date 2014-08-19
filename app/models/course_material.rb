class CourseMaterial < ActiveRecord::Base
  
  belongs_to :courses
  belongs_to :study_materials

  attr_accessible :course_id, :order, :study_material_id
  
end
