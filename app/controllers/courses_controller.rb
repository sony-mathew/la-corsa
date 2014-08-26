class CoursesController < ApplicationController

	before_filter :initial

	def index
		if params[:user_id].to_i == current_user.id
			@user_materials_flag = 1
			@courses = current_user.courses.paginate(:page => params[:page], :per_page => 15)
		else
			@courses = Course.paginate(:page => params[:page], :per_page => 15)
		end
	end

	def create
		@course = current_user.courses.new(params[:course])
		@course.course_materials_count = is_sufficient_materials
		if !@course.course_materials_count.nil?
			if @course.save
				add_study_materials_to_course
				@course = Course.new
				@message = "Your course was saved successfully."
			else
      			@message = "Sorry could not save your Study Material."
			end
		else
			@message = "Sorry, we could not save your course because you haven't added a single study material."	
		end 
		render 'new'
	end

	def new
		@course = Course.new
	end

	def edit
		begin
			@course = current_user.courses.find(params[:id])
			@study_materials = @course.study_materials
			render 'new'
		rescue Exception => e
			@message = "Could not edit the specified course as you are not it's owner or you provided an invalid Course ID."
			redirect_to user_courses_path(current_user)
		end
	end

	def show
		begin
			@course = Course.find(params[:id])
		rescue
			@message = "Could not find the course you specified."
			redirect_to user_courses_path(current_user)
		end
		@user_materials_flag = 1 if params[:user_id] == current_user.id
		@study_materials = @course.study_materials
	end

	def update
		@course = current_user.courses.find_by_id( params[:id])
		# # p '*'*100
		# # p is_sufficient_materials
		params[:course][:course_materials_count] = is_sufficient_materials
		#p params[:course].inspect
		if !is_sufficient_materials.nil?
				update_study_materials_of_course
				@course.update_attributes!(params[:course])
				@message = "successfully updated the course."
		else
			@message = "Sorry, we could not save your course because you haven't added a single study material."
		end
		@study_materials = @course.study_materials
		render 'new'
	end

	def destroy
		course = Course.find(params[:id])
		if course.learning_processes.empty?
			Course.find(params[:id]).destroy
  			@message = "successfully deleted the Course."
  		else
  			@message = course.learning_processes.count.to_s+" users are currently taking this course. So unable to delete this course."
  		end
  		@user_materials_flag = 1
  		@courses = current_user.courses.paginate(:page => params[:page], :per_page => 15)
  		render 'index'
	end

	def search
		@results = StudyMaterial.where("title like \"%#{params[:search]}%\"").limit(10)
		render json: @results
	end

	private

		def initial
			if !user_signed_in? 
				redirect_to new_user_session_path
			end
			@active = 'c'
			@nav_active = 'i'
			@mentor = 1
		end

		def add_study_materials_to_course
			study_material_ids = params[:material_ids].split(',').collect{|str| str.to_i}
			study_material_ids.each_with_index do | id, index |
				if id > 0
					course_material = @course.course_materials.new()
					course_material.order, course_material.study_material_id = index + 1, id
					course_material.save
				end
			end
		end

		def update_study_materials_of_course
			@course.course_materials.destroy_all
			@course.learning_processes.update_all("`last_material` = 0")
			add_study_materials_to_course
		end

		def is_sufficient_materials
			materials = params[:material_ids].split(',').collect{|str| str.to_i} 
			(materials.count == 0) ? nil : materials.count
		end
end