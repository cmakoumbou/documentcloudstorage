class DocumentsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :show, :index, :destroy, :get]
  before_filter :correct_user, only: [:show, :destroy, :get]

  def new
  	@document = current_user.documents.build
  end

  def create
  	@document = current_user.documents.build(params[:document])
  	if @document.save
      flash[:sucess] = "Document uploaded"
  		redirect_to @document
  	else
  		render 'new'
  	end
  end

  def show
  	@document = current_user.documents.find(params[:id])
  end

  def index
    @documents = current_user.documents
  end

  def destroy
    @document.destroy
    flash[:success] = "Document deleted"
    redirect_to :action => 'index'
  end

  def get
    send_file @document.uploaded_file.path, :type => @document.uploaded_file_content_type
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
      redirect_to :action => 'index' if @document.nil?
    end
end
