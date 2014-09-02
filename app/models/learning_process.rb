class LearningProcess < ActiveRecord::Base

	belongs_to :mentor , :class_name => "User", :foreign_key => "mentor"
	belongs_to :student, :class_name => "User", :foreign_key => "student"
	belongs_to :course


	attr_accessible :mentor, :student 
	attr_accessor :sample_variable

	validates :mentor, :presence => true
	validates :student, :presence => true
	validates :course_id, :presence => true

	scope :completed, -> { where("status = 0") }
	scope :dropped, -> { where("status = 1") }
	scope :pursuing, -> { where("status = 2 or status = 3") }

	default_scope :order => 'learning_processes.created_at DESC'

	after_save :simple_testing
	after_update :simple_testing
	before_save :simple_testing

	STATUSES_REV = {
		:Completed => 0,
		:Dropped => 1,
		:Pursuing => 2,
		:Suggested => 3}

	def simple_testing
		p "a"*1000
	end	
		
	def status_name
		STATUSES_REV.key(status)
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

	def drop!
		self.status = STATUSES_REV[:Dropped]
		save!
	end	

	def activate!
		self.status = (mentor == student ? STATUSES_REV[:Pursuing] : STATUSES_REV[:Suggested])
		save!
	end

	def enroll!( current_user)
		self.student = self.mentor = current_user
		self.status = STATUSES_REV[:Pursuing]
		save!
	end

	def finished_last_material!()
		self.last_material += 1
		self.status = STATUSES_REV[:Completed] if is_complete
		save!
	end

	def is_complete
		course.course_materials_count == last_material
	end

	def suggest_student!(current_user, suggested_to)
		self.mentor, self.student = current_user, suggested_to
		self.status = (mentor == student ? STATUSES_REV[:Pursuing] : STATUSES_REV[:Suggested])
		save!
	end

	def rate!
		self.rated = true
		save!
	end

end
