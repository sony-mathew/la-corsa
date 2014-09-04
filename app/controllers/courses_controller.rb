class CoursesController < ApplicationController

	before_filter :authenticate_user
	before_filter -> { set_tab false }, :except => [:show]
	before_filter -> { set_tab true }, :only => [:show]
	before_filter :load_courses, :only => [:index]
	before_filter :default_course_scope, :only => [:update, :destroy]

	def index
	end

	def create
		@course = current_user.courses.new(params[:course])
		if @course.sufficient_materials?
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
			default_course_scope
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
	end

	def update
		if params[:course][:material_ids].count > 0
				@course.update_attributes!(params[:course])
				flash[:success] = "successfully updated the course."
		else
			flash[:error] = "Sorry, we could not save your course because you haven't added a single study material."
		end
		redirect_to courses_path
	end

	def destroy
		if @course.learning_processes.exists?
			flash[:error] = "Coudn't delete because "+course.learning_processes.count.to_s+" users are currently taking this course."
  		else
  			@course.destroy
  			flash[:success] = "successfully deleted the Course."
  		end
  		redirect_to courses_path
	end

	private

		def set_tab(tab)
			@main_tab = params[:courses_filter] ? :open : (tab ? :learn : :teach)
			@sub_tab = :courses
		end


		def load_courses
			@courses = course_scope.paginate(:page => params[:page], :per_page => 15)
		end

		def course_scope
			(params[:courses_filter] == 'open') ? Course : current_user.courses
		end

		def default_course_scope
			@course = course_scope.find(params[:id])
		end
		
end