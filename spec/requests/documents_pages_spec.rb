require 'spec_helper'

describe "Document pages" do

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
    end

    describe "with file attached" do
    	before (:each) do
    		@file_attached = File.join(Rails.root, 'spec', 'support', 'doctor.txt')
    	end
    	before { attach_file('Uploaded file', @file_attached) }

    	it "should upload a document" do
    		expect { click_button submit }.to change(Document, :count).by(1)
    	end
    end
  end
end