class AddRatingFlagToLearningProcesses < ActiveRecord::Migration
  def change
    add_column :learning_processes, :rating_flag, :boolean
  end
end
