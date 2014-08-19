class CreateLearningProcesses < ActiveRecord::Migration
  def change
    create_table :learning_processes do |t|
      t.integer :mentor
      t.integer :student
      t.integer :course_id
      t.string :status
      t.integer :last_material

      t.timestamps
    end
  end
end
