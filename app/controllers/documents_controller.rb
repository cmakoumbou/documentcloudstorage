class DocumentsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :show, :index]
  before_filter :correct_user, only: [:show]

  def new
  	@document = current_user.documents.build
  end

  def create
  	@document = current_user.documents.build(params[:document])
  	if @document.save
  		redirect_to @document
  	else
  		render 'new'
  	end
  end

  def show
  	@document = current_user.documents.find(params[:id])
  end

  def index
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @document = current_user.documents.find_by_id(params[:id])
      redirect_to(root_path) if @document.nil?
    end
end
