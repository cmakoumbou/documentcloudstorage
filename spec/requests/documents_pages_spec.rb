require 'spec_helper'

describe "Document pages" do

  before do
    @alpha = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'doctor.txt'))
    @beta = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'hello.txt'))
    @delta = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'moon.txt'))
  end

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "new document page" do
    before { visit new_document_path }

    it { should have_selector('h1',    text: 'Upload') }
    it { should have_selector('title', text: full_title('Upload')) }

    let(:submit) { "Upload" }

    describe "with no file attached" do
    	it "should not upload a document" do
    		expect { click_button submit }.not_to change(Document, :count)
    	end

      describe "it should show an error message" do
        before { click_button submit }
        it { should have_content('error') }
      end
    end

    describe "with file attached" do
    	before (:each) do
    		@file_attached = File.join(Rails.root, 'spec', 'support', 'doctor.txt')
    	end
    	before { attach_file('Uploaded file', @file_attached) }

    	it "should upload a document" do
    		expect { click_button submit }.to change(Document, :count).by(1)
    	end

      describe "it should show a success message" do
        before { click_button submit }
        it { should have_content('Document uploaded') }
      end
    end
  end

  describe "show document page" do
    let!(:document) { FactoryGirl.create(:document, user: user, uploaded_file: @alpha) }

    before { visit document_path(document) }

    it { should have_selector('h1', text: 'Show document') }
    it { should have_selector('title', text: full_title('Show document')) }

    describe "documents" do
      it { should have_content(document.uploaded_file_file_name) }
    end
  end

  describe "index document page" do
    before do
      FactoryGirl.create(:document, user: user, uploaded_file: @alpha) 
      FactoryGirl.create(:document, user: user, uploaded_file: @beta) 
      FactoryGirl.create(:document, user: user, uploaded_file: @delta) 
      visit documents_path
    end

    it { should have_selector('title', text: 'All documents') }
    it { should have_selector('h1', text: 'All documents') }

    it "should list the user's document" do
      user.documents.all.each do |document|
        page.should have_selector('li', text: document.uploaded_file_file_name)
      end
    end
  end

  describe "delete document" do
    before { FactoryGirl.create(:document, user: user, uploaded_file: @beta) }

    describe "as correct user" do
      before { visit documents_path }

      it "should delete a document" do
        expect { click_link "delete" }.to change(Document, :count).by(-1)
      end
    end
  end
end