# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  last_name       :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_many :documents, dependent: :destroy
  has_many :folders, dependent: :destroy

  before_save { self.email.downcase! }
  before_save :create_remember_token

  # validates :first_name, presence: true, length: { maximum: 50 }
  # validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, :email_format => {},
  				uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
