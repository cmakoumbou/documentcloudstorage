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

class Folder < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_many :documents

  has_ancestry

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }

  default_scope order: 'folders.name ASC'
end
