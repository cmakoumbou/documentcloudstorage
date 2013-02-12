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

class Document < ActiveRecord::Base
  attr_accessible :uploaded_file
  belongs_to :user

  has_attached_file :uploaded_file

  validates :user_id, presence: true
  validates_attachment_size :uploaded_file, :less_than => 10.megabytes
  validates_attachment_presence :uploaded_file

  default_scope order: 'documents.uploaded_file_file_name ASC'
end
