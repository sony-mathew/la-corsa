class CreateStudyMaterials < ActiveRecord::Migration
  def change
    create_table :study_materials do |t|
      t.string 	:title
      t.string 	:description
      t.string 	:link
      t.integer :user_id

      t.timestamps
    end
  end
end
