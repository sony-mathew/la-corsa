class LearningProcessesController < ApplicationController

	before_filter :set_tabs

	def students
		@students = current_user.occurences_as_mentor.paginate(:page => params[:page], :per_page => 15)
	end

	def courses
		if params[:status] == "dropped"
			@courses = current_user.occurences_as_student.where("status = 1").paginate(:page => params[:page], :per_page => 15)
		elsif params[:status] == "completed"
			@courses = current_user.occurences_as_student.where("status = 0").paginate(:page => params[:page], :per_page => 15)
		else
			@courses = current_user.occurences_as_student.where("status = 2 or status =3").paginate(:page => params[:page], :per_page => 15)
		end
	end

	def drop_course
		if params[:lp_id]
			lp = LearningProcess.find(params[:lp_id])
			lp.status = 1
			lp.save
			render text: "Success"
		else
			render text: "Error"
		end
	end

	def activate_course
		if params[:lp_id]
			lp = LearningProcess.find(params[:lp_id])
			lp.status = (current_user.id == lp.mentor.id) ? 2 : 3
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
			lp.status = 0 if lp.last_material == lp.course.course_materials_count
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
				lp[:mentor], lp[:student], lp[:course_id], lp[:status] = current_user.id, current_user.id, params[:course_id].to_i, 2
				lp.save
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
				reg = user[0].occurences_as_student.where("`course_id` = "+params[:course])
				if reg.empty?
					lp = LearningProcess.new
					lp.mentor, lp.student, lp.course_id = current_user.id, user[0].id, params[:course]
					lp.status = (current_user.id == user[0].id) ? 2 : 3
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

	def rate_course
		@lp = LearningProcess.where("course_id = "+params[:course]+" and student = "+current_user.id.to_s)
		if @lp.not_rated?
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
			@lp.rating_flag = 1
			course = Course.find(params[:course])
			course.rating_user_count += 1
			course.rating = (course.rating+params[:rating].to_f)/course.rating_user_count
			course.save
			@lp.save
		end
end