class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string 	:name
      t.text 	:description
      t.integer :user_id
      t.decimal	:rating
      t.integer :rating_user_count
      t.integer	:course_completed_count
      t.integer :current_users_count
      t.integer :course_materials_count

      t.timestamps
    end
  end
end
