class User < ActiveRecord::Base

	has_many :study_materials
	has_many :courses

	has_many :occurences_as_mentor , :class_name => "LearningProcess", :foreign_key => "mentor"
	has_many :occurences_as_student, :class_name => "LearningProcess", :foreign_key => "student"

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :dob, :nickname
	# attr_accessible :title, :body



end
