class ProjectsController < ApplicationController

	before_filter :find_project, :only => [:show, :edit, :update, :destroy]	
	before_filter :authorize_admin!, :except => [:index, :show]
	before_filter :authenticate_user!, :only => [:index, :show]
	before_filter :find_project, :only => [:show, :edit, :update, :destroy]
	
	def index
		@projects = Project.for(current_user).all
	end
	def new
		@project = Project.new(params[:project])
		@project.save
	end
	def create
		@project = Project.new(params[:project])
		if @project.save
			flash[:notice] = "Project has been created."
			redirect_to @project
		else
			flash[:alert] = "Project has not been created."
			render :action => "new"
		end
	end	
	def edit
	@project = Project.for(current_user).find(params[:id])
	end
	def update
	@project = Project.for(current_user).find(params[:id])
		if @project.update_attributes(params[:project])
			flash[:notice] = "Project has been updated."
			redirect_to @project
		else
			flash[:alert] = "Project has not been updated."
			render :action => "edit"
		end
	end
	def destroy
	@project = Project.for(current_user).find(params[:id])
		@project.destroy
		flash[:notice] = "Project has been deleted."
		redirect_to projects_path
	end
	def show
		@tickets = @project.tickets
		
	end
	private
    def find_project
      @project = if current_user.admin?
        Project.find(params[:id])
      else
        Project.readable_by(current_user).find(params[:id])
      end
      rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The project you were looking" +
                      " for could not be found."
      redirect_to projects_path
    end
    
    def check_for_sign_up
      if request.referer == user_registration_url
        redirect_to confirm_user_path
      end
    end
end