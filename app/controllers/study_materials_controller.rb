class StudyMaterialsController < ApplicationController

	before_filter :initial

	def index
		if params[:user_id].to_i == current_user.id
			@user_materials_flag = 1
			@study_materials = current_user.study_materials.paginate(:page => params[:page], :per_page => 15)
		else
			@study_materials = StudyMaterial.paginate(:page => params[:page], :per_page => 15)
		end
	end

	def create
		@study_material = current_user.study_materials.new(params[:study_material]) 
		if @study_material.save
			@message = "Study Material saved successfully."
			@study_material = StudyMaterial.new
			render 'new'
		else
      		@message = "Sorry could not save your Study Material."
			render 'new'
		end 
	end

	def new
		@study_material = StudyMaterial.new
	end

	def edit
		begin
			@study_material = current_user.study_materials.find(params[:id])
			render 'new'
		rescue Exception => e
			@message = "Could not edit the specified material as you are not it's owner or you provided an invalid Study Material ID."
			redirect_to user_study_materials_path(current_user)
		end
	end

	def show
		begin
			@study_material = StudyMaterial.find(params[:id])
		rescue
			@message = "Could not find the study material you specified."
			redirect_to user_study_materials_path(current_user)
		end
	end

	def update
		@study_material = StudyMaterial.find( params[:id])
		if @study_material.update_attributes(params[:study_material])
			@message = "Study Material updated."
			@study_materials = current_user.study_materials.paginate(:page => params[:page], :per_page => 15)
			@user_materials_flag = 1
			render 'index'
		else
			@title = "Edit user"
			render 'new'
		end
	end
	
	def destroy
		course = StudyMaterial.find(params[:id]).courses
		if course
			@message = "Could not delete the study material as it is already part of a course."
		else
  			StudyMaterial.find(params[:id]).destroy
  			@message = "Successfully deleted the Study Material."
  		end
  		@user_materials_flag = 1
  		@study_materials = current_user.study_materials.paginate(:page => params[:page], :per_page => 15)
  		render 'index'
	end

	private

		def initial
			@active = 'a'
			@nav_active = 'i'
			@mentor = 1
		end



end