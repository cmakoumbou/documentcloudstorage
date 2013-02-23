require 'spec_helper'

describe "Static pages" do

  before do
    @alpha = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'doctor.txt'))
    @beta = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'hello.txt'))
    @delta = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'moon.txt'))
  end

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',  text: heading) }
    it { should have_selector('title',  text: full_title(page_title)) }
  end

  describe "Home page for non-signed-in users" do
    before { visit root_path }
    let(:heading) {'Sample App'}
    let(:page_title) {''}

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home'}
  end

  describe "Home page for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      FactoryGirl.create(:document, user: user, uploaded_file: @alpha) 
      FactoryGirl.create(:document, user: user, uploaded_file: @beta) 
      FactoryGirl.create(:document, user: user, uploaded_file: @delta)
      FactoryGirl.create(:folder, user: user, name: "Project A")
      FactoryGirl.create(:folder, user: user, name: "Project B")
      FactoryGirl.create(:folder, user: user, name: "Project C")
      visit root_path
    end

    it "should list the user's document" do
      user.documents.all.each do |document|
        page.should have_selector('li', text: document.file_name)
      end
    end

    it "should list the user's folder" do
      user.folders.all.each do |folder|
        page.should have_selector('li', text: folder.name)
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) {'Help'}
    let(:page_title) {'Help'}

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) {'About'}
    let(:page_title) {'About'}

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
  end
end