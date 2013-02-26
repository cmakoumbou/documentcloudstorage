# == Schema Information
#
# Table name: documents
#
#  id                         :integer          not null, primary key
#  user_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  uploaded_file_file_name    :string(255)
#  uploaded_file_content_type :string(255)
#  uploaded_file_file_size    :integer
#  uploaded_file_updated_at   :datetime
#  folder_id                  :integer
#

require 'spec_helper'

describe Document do

  let(:user) { FactoryGirl.create(:user) }
  let(:folder) { FactoryGirl.create(:folder) }
  before do
    @document = user.documents.build(:uploaded_file => File.new(File.join(Rails.root, 'spec', 'support', 'hello.txt')))
    @document.folder = folder
    @document.save
  end

  subject { @document }

  it { should have_attached_file(:uploaded_file) }
  it { should validate_attachment_presence(:uploaded_file) }
  it { should validate_attachment_size(:uploaded_file).less_than(10.megabytes) }


  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should respond_to(:folder_id) }
  it { should respond_to(:folder) }
  its(:folder) { should == folder }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @document.user_id = nil }
  	it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect do
  			Document.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end

    it "should not allow access to folder_id" do
      expect do
        Document.new(folder_id: '1')
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
