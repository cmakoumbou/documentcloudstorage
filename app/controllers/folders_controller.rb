class FoldersController < ApplicationController
	before_filter :signed_in_user, only: [:new, :create, :index, :show, :edit, :update, :destroy]
	before_filter :correct_user, only: [:show, :edit, :update, :destroy]
	# Correct user for edit, show, and etc
	
	def new
		@folder = current_user.folders.build
	end

	def create
		@folder = current_user.folders.build(params[:folder])
		if @folder.save
			flash[:success] = "Folder created!"
			redirect_to @folder
		else
			render 'new'
		end
	end

	def index
    	@folders = current_user.folders
  	end

	def show
		@folder = current_user.folders.find(params[:id])
	end

	def edit
		@folder = current_user.folders.find(params[:id])
	end

	def update
		@folder = current_user.folders.find(params[:id])
		if @folder.update_attributes(params[:folder])
			flash[:success] = "Folder updated"
			redirect_to @folder
		else
			render 'edit'
		end
	end

	def destroy
		@folder.destroy
		redirect_to :action => 'index'
	end

	private

    	def correct_user
      		@folder = current_user.folders.find_by_id(params[:id])
      		redirect_to :action => 'index' if @folder.nil?
    	end
end
