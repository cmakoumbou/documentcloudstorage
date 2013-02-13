class DocumentsController < ApplicationController

  def new
  	@document = current_user.documents.new
  end

  def create
  	@document = current_user.documents.new(params[:document])
  	if @document.save
  		redirect_to @document
  	else
  		render 'new'
  	end
  end

  def show
  	@document = current_user.documents.find(params[:id])
  end
end
