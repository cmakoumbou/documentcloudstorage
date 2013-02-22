# == Schema Information
#
# Table name: folders
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string(255)
#

require 'spec_helper'

describe Folder do

  let(:user) { FactoryGirl.create(:user) }
  before { @folder = user.folders.build(name: "Project A") }
 
  subject { @folder }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @folder.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
  	before { @folder.name = " " }
  	it { should_not be_valid }
  end

  describe "with name that is too long" do
  	before { @folder.name = "a" * 256 }
  	it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect do
  			Folder.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end
end
