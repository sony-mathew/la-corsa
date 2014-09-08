class LearningProcessesController < ApplicationController

	before_filter :authenticate_user
	before_filter :set_tab

	SCOPES = [:dropped, :completed, :pursuing]

	def index
		redirect_to root_path
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
		begin 
			render text:  (current_user.occurences_as_student.where(course_id: params[:course_id]).exists? ? "Already Enrolled" : 
						(course_scope_default.learning_processes.new.enroll!(current_user) ? "Success" : "Error" ))
		rescue ActiveRecord::RecordNotFound
			render text: "Record not found"
		end
	end

	def suggest
		if user_scope.empty?
			render text: " Email ID not registered "
		else
			if user_scope.first.occurences_as_student.where(course_id: params[:course_id]).exists?
				render text: " Already enrolled "
			else
				render text: (course_scope_default.learning_processes.new.suggest_student!(current_user, user_scope.first) ? "Success" : "Error")
			end
		end
	end


	def rate_course
		@lp = current_user.occurences_as_student.find_by_id(params[:lp_id])
		render text: (@lp.rated? ? "Error" :(update_rating ? "Success" : "Error"))
	end

	private

		def set_tab
			@main_tab = params[:status] ? :learn : :teach
			@sub_tab = params[:status] ? params[:status].to_sym : :students
		end

		def update_rating
			return false unless @lp.rate!
			Course.find(@lp.course_id).rate!( params[:rating].to_f)
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