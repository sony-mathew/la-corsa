class LearningProcess < ActiveRecord::Base

	belongs_to :mentor , :class_name => "User", :foreign_key => "mentor"
	belongs_to :student, :class_name => "User", :foreign_key => "student"
	belongs_to :course


	attr_accessible :mentor, :student

	validates :mentor, :presence => true
	validates :student, :presence => true
	validates :course_id, :presence => true

	default_scope :order => 'learning_processes.created_at DESC'

	STATUSES = [ :Completed, :Dropped, :Pursuing, :Suggested ]

	STATUSES_REV = {
		:Completed => 0,
		:Dropped => 1,
		:Pursuing => 2,
		:Suggested => 3}

	def status_name
		STATUSES[self.status]
	end

	def complete?
		status == STATUSES_REV[:Completed]
	end

	def dropped?
		status == STATUSES_REV[:Dropped]
	end

	def pursuing?
		status == STATUSES_REV[:Pursuing]
	end

	def suggested?
		status == STATUSES_REV[:Suggested]
	end	

	def is_self_student?
		!(self.student == self.mentor)
	end

	def cool_man
		self.rating_flag == 0
	end
end
