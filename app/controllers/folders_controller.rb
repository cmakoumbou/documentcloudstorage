class FoldersController < ApplicationController
	before_filter :signed_in_user, only: [:new, :show, :create, :destroy]
	before_filter :correct_user, only: [:destroy]
	
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
