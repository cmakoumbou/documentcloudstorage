class HomeController < ApplicationController

	def index
  	if signed_in?
			@folders = current_user.folders
			@documents = current_user.documents
		end
	end

	def browse
	end
end
