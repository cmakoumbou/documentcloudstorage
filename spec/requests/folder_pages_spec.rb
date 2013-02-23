require 'spec_helper'

describe "FolderPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
  	before { sign_in user }

	describe "new folder page" do
		before { visit new_folder_path }

		it { should have_selector('h1', text: 'New folder') }
		it { should have_selector('title', text: full_title('New folder')) }

		describe "with invalid information" do
			it "should not create a folder" do
				expect { click_button "Create folder" }.not_to change(Folder, :count)
			end

			describe "error messages" do
				before { click_button "Create folder" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before { fill_in 'folder_name', with: "Project A" }
			it "should create a folder" do
				expect { click_button "Create folder" }.to change(Folder, :count).by(1)
			end

			describe "it should show a success message" do
        		before { click_button "Create folder" }
        		it { should have_content('Folder created') }
      		end
		end
	end

	describe "show folder page" do
		let!(:folder) { FactoryGirl.create(:folder, user: user, name: "Project A") }

		before { visit folder_path(folder) }

		it { should have_selector('h1', text: "Show folders") }
		it { should have_selector('title', text: full_title('Show folders')) }

		describe "folders" do
			it { should have_content(folder.name) }
		end
	end

	describe "index folder page" do
		before do
			FactoryGirl.create(:folder, user: user, name: 'alpha')
			FactoryGirl.create(:folder, user: user, name: 'beta')
			FactoryGirl.create(:folder, user: user, name: 'delta')
			visit folders_path
		end

		it { should have_selector('title', text: 'All folders') }
		it { should have_selector('h1', text: 'All folders') }

		it "should list the user's folder" do
			user.folders.all.each do |folder|
				page.should have_selector('li', text: folder.name)
			end
		end
	end

	describe "delete folder" do
		before { FactoryGirl.create(:folder, user: user) }

		describe "as correct user" do
			before { visit folders_path }

			it "should delete a folder" do
				expect { click_link "delete" }.to change(Folder, :count).by(-1)
			end
		end
	end
end