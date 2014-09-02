class CoursesController < ApplicationController

	before_filter :authenticate_user
	before_filter :select_tab, :except => [:show]
	before_filter :load_courses, :only => [:index]

	def index
	end

	def create
		@course = current_user.courses.new(params[:course])
		if @course.is_sufficient_materials?
			if @course.save
				flash[:success] = "Your course was saved successfully."
			else
      			flash[:error] = "Sorry could not save your Study Material."
			end
		else
			flash[:error] = "Sorry, we could not save your course because you haven't added a single study material."	
		end 
		redirect_to new_course_path
	end

	def new
		@course = Course.new
	end

	def edit
		begin
			@course = current_user.courses.find(params[:id])
			@study_materials = @course.study_materials
			render 'new'
		rescue ActiveRecord::RecordNotFound
			flash[:error] = "Could not edit the specified course as you are not it's owner or you provided an invalid Course ID."
			redirect_to courses_path(current_user)
		end
	end

	def show
		begin
			@course = Course.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			flash[:error] = "Could not find the course you specified."
			redirect_to courses_path(current_user)
		end
		@study_materials = @course.study_materials
		@learn_tab = true
	end

	def update
		@course = current_user.courses.find_by_id( params[:id])
		if @course.is_sufficient_materials?
				@course.update_attributes!(params[:course])
				flash[:success] = "successfully updated the course."
		else
			flash[:error] = "Sorry, we could not save your course because you haven't added a single study material."
		end
		redirect_to courses_path
	end

	def destroy
		course = Course.find(params[:id])
		if course.learning_processes.empty?
			Course.find(params[:id]).destroy
  			flash[:success] = "successfully deleted the Course."
  		else
  			flash[:error] = course.learning_processes.count.to_s+" users are currently taking this course. So unable to delete this course."
  		end
  		redirect_to courses_path
	end

	private

		def select_tab
			@teach_tab = true
			@courses_sub_tab = true
		end

		def load_courses
			if params[:courses_filter] == 'all' or params[:courses_filter] == 'open'
				@courses = Course.paginate(:page => params[:page], :per_page => 15)
				@teach_tab, @open_courses_tab = params[:courses_filter] == 'open' ? [false, true] : [true, false]
			else
				@courses = current_user.courses.paginate(:page => params[:page], :per_page => 15)
			end
		end
		
end