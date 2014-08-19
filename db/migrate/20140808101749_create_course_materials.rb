class CreateCourseMaterials < ActiveRecord::Migration
  def change
    create_table :course_materials do |t|
      t.integer :course_id
      t.integer :study_material_id
      t.integer :order

      t.timestamps
    end
  end
end
