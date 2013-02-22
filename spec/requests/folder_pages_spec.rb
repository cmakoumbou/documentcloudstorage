require 'spec_helper'

describe "FolderPages" do

	subject { page }

	describe "new folder page" do
		before { visit new_folder_path }

		it { should have_selector('h1', text: 'New folder') }
		it { should have_selector('title', text: full_title('New folder')) }
	end
end