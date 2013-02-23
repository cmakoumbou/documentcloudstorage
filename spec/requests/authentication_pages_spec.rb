require 'spec_helper'

describe "Authentication" do

  before do
    @alpha = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'doctor.txt'))
  end

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_content('Invalid email/password combination') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_content('Invalid email/password combination') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_link('Users',   href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "when attempting to access the new action" do
        before { get new_user_path }
        specify { response.should redirect_to(root_path) }
      end

      describe "when attempting to access the create action" do
        before { post users_path }
        specify { response.should redirect_to(root_path) }
      end 
    end

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:document) { FactoryGirl.create(:document, user: user, uploaded_file: @alpha) }
      let(:folder) { FactoryGirl.create(:folder, user: user, name: "Project A") }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (home) page" do
              page.should have_selector('title', text: full_title('')) 
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end

      describe "in the Documents controller" do

        describe "when attempting to access the new action" do
          before { get new_document_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the create action" do
          before { post documents_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "when attempting to access the show action" do
          before { get document_path(document) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the document index" do
          before { visit documents_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the destroy action" do
          before { delete document_path(document) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the get action" do
          before { get download_path(document) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the Folders controller" do

        describe "when attempting to access the new action" do
          before { get new_folder_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the create action" do
          before { post folders_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "when attempting to access the show action" do
          before { get folder_path(folder) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the folder index" do
          before { visit folders_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the destroy action" do
          before { delete folder_path(FactoryGirl.create(:folder)) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the edit page" do
          before { visit edit_folder_path(folder) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put folder_path(folder) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      let!(:wrong_document) { FactoryGirl.create(:document, user: wrong_user, uploaded_file: @alpha) }
      let!(:wrong_folder) { FactoryGirl.create(:folder, user: wrong_user, name: "Project Wrong") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end

      describe "submitting a GET request to the Documents#show action" do
        before { get document_path(wrong_document) }
        specify { response.should redirect_to(documents_path) }
      end

      describe "submitting a DELETE request to the Documents#destroy action" do
        before { delete document_path(wrong_document) }
        specify { response.should redirect_to(documents_path) }
      end

      describe "submitting a GET request to the Documents#get action" do
        before { delete document_path(wrong_document) }
        specify { response.should redirect_to(documents_path) }
      end

      describe "visiting Folders#edit page" do
        before { visit edit_folder_path(wrong_folder) }
        it { should_not have_selector('title', text: full_title('Edit folder')) }
      end

      describe "submitting a PUT request to the Folders#update action" do
        before { put folder_path(wrong_folder) }
        specify { response.should redirect_to(folders_path) }
      end

      describe "submitting a GET request to the Folders#show action" do
        before { get folder_path(wrong_folder) }
        specify { response.should redirect_to(folders_path) }
      end

      describe "submitting a DELETE request to the Folders#destroy action" do
        before { delete folder_path(wrong_folder) }
        specify { response.should redirect_to(folders_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) } 
      before { sign_in admin }

      it "should not be allowed to delete itself" do
        expect { delete user_path(admin), method: :delete }.not_to change(User, :count)
      end
    end
  end
end
