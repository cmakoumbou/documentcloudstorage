class StaticPagesController < ApplicationController
	def home
		if signed_in?
			@documents = current_user.documents
		end
	end

	def help
	end

	def about
	end

	def contact
	end
end
