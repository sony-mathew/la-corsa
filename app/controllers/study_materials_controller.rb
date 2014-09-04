class StudyMaterialsController < ApplicationController

	before_filter :authenticate_user, :set_tab
	before_filter :edit_title , :only => [:edit, :update]
	before_filter :load_study_materials, :only => [:index]

	def index
	end

	def create
		@study_material = current_user.study_materials.new(params[:study_material]) 
		if @study_material.save
			flash[:success] = "Study Material saved successfully."
		else
      		flash[:error] = "Sorry could not save your Study Material."
		end 
		redirect_to new_study_material_path
	end

	def new
		@study_material = StudyMaterial.new
	end

	def edit
		begin
			@study_material = default_study_scope
			render 'new'
		rescue ActiveRecord::RecordNotFound
			flash[:error] = "Could not edit the specified material as you are not it's owner or you provided an invalid Study Material ID."
			redirect_to study_materials_path
		end
	end

	def show
		begin
			@study_material = StudyMaterial.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			flash[:error] = "Could not find the study material you specified."
			redirect_to study_materials_path
		end
	end

	def update
		@study_material = default_study_scope
		if @study_material.update_attributes(params[:study_material])
			flash[:success] = "Study Material updated."
			redirect_to study_materials_path
		else
			flash[:error] = "Could not update the material."
			render 'new'
		end
	end
	
	def destroy
		if default_study_scope.courses.exists?
			flash[:error] = "Could not delete the study material as it is already part of a course."
		else
			begin
  				default_study_scope.destroy
  				flash[:success] = "Successfully deleted the Study Material."
  			rescue	ActiveRecord::RecordNotFound
  				flash[:error] = "Could not delete the specified material."
  			end
  		end
  		redirect_to study_materials_path
	end

	def search
		@results = StudyMaterial.where(['title LIKE ?', "%#{params[:search]}%"]).limit(10)
		render json: @results
	end

	private

		def set_tab
			@main_tab = :teach
			@sub_tab = :study_materials
		end

		def edit_title
			@title = "Edit Material"
		end

		def load_study_materials
			@study_materials = study_scope.paginate(:page => params[:page], :per_page => 15)
		end

		def study_scope
			params[:materials_filter] == 'all'? StudyMaterial : current_user.study_materials
		end

		def default_study_scope
			study_scope.find(params[:id])
		end

end