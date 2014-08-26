class LearningProcessesController < ApplicationController

	before_filter :initial

	def students
		@students = current_user.occurences_as_mentor.paginate(:page => params[:page], :per_page => 15)
	end

	def courses
		if params[:status] == "dropped"
			@courses = current_user.occurences_as_student.where("status = 'DROPPED'").paginate(:page => params[:page], :per_page => 15)
		elsif params[:status] == "completed"
			@courses = current_user.occurences_as_student.where("status = 'COMPLETED'").paginate(:page => params[:page], :per_page => 15)
		else
			@courses = current_user.occurences_as_student.where("status = 'ON' or status ='SUGGESTED'").paginate(:page => params[:page], :per_page => 15)
		end
	end

	def drop_course
		if params[:lp_id]
			lp = LearningProcess.find(params[:lp_id])
			lp.status = "DROPPED"
			lp.save
			render text: "Success"
		else
			render text: "Error"
		end
	end

	def activate_course
		if params[:lp_id]
			lp = LearningProcess.find(params[:lp_id])
			lp.status = "ON"
			lp.save
			render text: "Success"
		else
			render text: "Error"
		end
	end

	def finished_material
		if params[:lp_id]
			lp = LearningProcess.find(params[:lp_id])
			lp.last_material += 1
			lp.save
			render text: "Success"
		else
			render text: "Error"
		end
	end

	def enroll_me
		if params[:course_id]
			reg = current_user.occurences_as_student.where("`course_id` = "+params[:course_id])
			if reg.empty?
				lp = LearningProcess.new
				lp[:mentor], lp[:student], lp[:course_id], lp[:status] = current_user.id, current_user.id, params[:course_id].to_i, "ON"
				lp.save
				render text: "Success"
			else
				render text: "Already Enrolled"
			end
		else
			render text: "Error"
		end
	end

	def suggest_course
		if params[:email]
			user = User.where("`email` = '"+params[:email]+"'")
			if user.empty?
				render text: " Email ID not registered "
			else
				reg = user[0].occurences_as_student.where("`course_id` = "+params[:course])
				if reg.empty?
					lp = LearningProcess.new
					lp.mentor, lp.student, lp.course_id = current_user.id, user[0].id, params[:course]
					lp.status = (current_user.id == user[0].id) ? "ON" : "SUGGESTED"
					lp.save
					render text: "Success"
				else
					render text: " Already enrolled "
				end
			end
		else
			render text: " No email parameter "
		end
	end

	private

		def initial
			if !params[:status]
				@active = 't'
				@nav_active = 'i'
				@mentor = 1
			else
				@active = (params[:status] == "dropped" ? 't' : (params[:status] == "completed" ? 'c' : 'a'))
				@nav_active = 't'
				@student = 1
			end
		end
end