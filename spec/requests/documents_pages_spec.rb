require 'spec_helper'

describe "Document pages" do

  subject { page }

  describe "new document page" do
    before { visit new_document_path }

    it { should have_selector('h1',    text: 'Upload') }
    it { should have_selector('title', text: full_title('Upload')) }
  end
end