class User < ActiveRecord::Base

	has_many :study_materials, :dependent => :destroy
	has_many :courses, :dependent => :destroy

	has_many :occurences_as_mentor , :class_name => "LearningProcess", :foreign_key => "mentor", :dependent => :destroy
	has_many :occurences_as_student, :class_name => "LearningProcess", :foreign_key => "student", :dependent => :destroy

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable

	validates :name, :presence => true, :length => { :maximum => 20, :minimum => 3 }
	validates :dob, :presence => true, :length => { :is => 10}
	validates :nickname, :presence => true, :length => { :maximum => 10, :minimum => 2 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  	validates :password, presence: true, length: { minimum: 8 }
  	validates :password_confirmation, presence: true

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :dob, :nickname

	

end
