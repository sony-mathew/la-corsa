class LearningProcessesController < ApplicationController

	before_filter :authenticate_user
	before_filter :set_tab

	SCOPES = [:dropped, :completed, :pursuing]

	def index
		redirect_to root
	end

	def students
		@students = current_user.occurences_as_mentor.where('mentor != student').paginate(:page => params[:page], :per_page => 15)
	end

	def courses
		@courses = current_user.occurences_as_student.send(course_scope).paginate(:page => params[:page], :per_page => 15)
	end

	def drop_course
		render text: (default_lp_scope.drop! ? "Success" : "Error")
	end

	def activate_course
		render text: (default_lp_scope.activate! ? "Success" : "Error")
	end

	def finished_material
		render text: (default_lp_scope.finished_last_material! ? "Success" : "Error")
	end

	def enroll_me
		render text: "Error" unless params[:course_id]
		render text: "Already Enrolled" if current_user.occurences_as_student.where(course_id: params[:course_id]).exists?
		render text: ( course_scope_default.learning_processes.new.enroll!(current_user) ? "Success" : "Error" )
	end

	def suggest
		render text: " Email ID not registered " unless user_scope.exists?
		render text: " Already enrolled " if user_scope.first.occurences_as_student.where(course_id: params[:course]).exists?
		render text: (course_scope_default.learning_processes.new.suggest_student!(current_user, user.first) ? "Success" : "Error")
	end


	def rate_course
		@lp = LearningProcess.where(course_id: params[:course], student: current_user.id).first
		(render text: "Success" if update_rating) unless @lp.rated?
		render text: "Error"
	end

	private

		def set_tab
			@main_tab = params[:status] ? :learn : :teach
			@sub_tab = params[:status] ? params[:status].to_sym : :students
		end

		def update_rating
			@lp.rate!
			Course.find(params[:course]).rate!( params[:rating].to_f)
		end

		def course_scope
			SCOPES.include?(params[:status].to_sym) ? params[:status].to_sym : SCOPES.last
		end

		def default_lp_scope
			LearningProcess.find(params[:lp_id]) if params[:lp_id]
		end

		def course_scope_default
			Course.find(params[:course_id])
		end

		def user_scope
			User.where(email: params[:email])
		end
end