class LearningProcessesController < ApplicationController

	before_filter :set_tabs

	SCOPES = [:dropped, :completed, :pursuing]

	def students
		@students = current_user.occurences_as_mentor.paginate(:page => params[:page], :per_page => 15)
	end

	def courses
		@courses = current_user.occurences_as_student.send(course_scope).paginate(:page => params[:page], :per_page => 15)
	end

	def drop_course
		if params[:lp_id]
			LearningProcess.find(params[:lp_id]).drop!
			render text: "Success"
		else
			render text: "Error"
		end
	end

	def activate_course
		if params[:lp_id]
			LearningProcess.find(params[:lp_id]).activate!
			render text: "Success"
		else
			render text: "Error"
		end
	end

	def finished_material
		if params[:lp_id]
			LearningProcess.find(params[:lp_id]).finished_last_material!
			debug("dhfkjhfs")
			render text: "Success"
		else
			render text: "Error"
		end
	end

	def enroll_me
		if params[:course_id]
			reg = current_user.occurences_as_student.where("`course_id` = "+params[:course_id])
			if reg.empty?
				Course.find(params[:course_id]).learning_processes.new.enroll!(current_user)
				render text: "Success"
			else
				render text: "Already Enrolled"
			end
		else
			render text: "Error"
		end
	end

	def suggest
		if params[:email]
			user = User.where("`email` = '"+params[:email]+"'")
			if user.empty?
				render text: " Email ID not registered "
			else
				reg = user.first.occurences_as_student.where("`course_id` = "+params[:course])
				if reg.empty?
					Course.find(params[:course]).learning_processes.new.suggest_student!(current_user, user.first)
					render text: "Success"
				else
					render text: " Already enrolled "
				end
			end
		else
			render text: " No email parameter "
		end
	end

	def rate_course
		@lp = LearningProcess.where("course_id = "+params[:course]+" and student = "+current_user.id.to_s).first
		unless @lp.rated?
			update_rating
			render text: "Success"
		else
			render text: " Already Rated "
		end
	end

	private

		def set_tabs
			if !params[:status]
				@teach_tab = true
				@students_sub_tab = true
			else
				@learn_tab = true
				@current_sub_tab = true if params[:status] == "current"
				@completed_sub_tab = true if params[:status] == "completed"
				@dropped_sub_tab = true if params[:status] == "dropped"
			end
		end

		def update_rating
			@lp.rate!
			Course.find(params[:course]).rate!( params[:rating].to_f)
		end

		def course_scope
			SCOPES.include?(params[:status].to_sym) ? params[:status].to_sym : SCOPES.last
		end
end