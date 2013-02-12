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
#

require 'spec_helper'

describe Document do

  let(:user) { FactoryGirl.create(:user) }
  before { @document = user.documents.build(:uploaded_file => File.new(File.join(Rails.root, 'spec', 'support', 'hello.txt'))) }

  subject { @document }

  it { should have_attached_file(:uploaded_file) }
  it { should validate_attachment_presence(:uploaded_file) }
  it { should validate_attachment_size(:uploaded_file).less_than(10.megabytes) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

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
  end
end
