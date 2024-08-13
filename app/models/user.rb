require 'elasticsearch/model'
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  acts_as_tenant :organization
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users, dependent: :destroy

  belongs_to :role, class_name: 'Role', foreign_key: 'role_id'
  validates :name, presence: true
  validates_uniqueness_to_tenant :email
  validates :password, presence: true, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def mark_as_confirmed
    self.confirmation_token = nil
    self.confirmed_at = Time.now
  end
  before_create :generate_invitation_token

  def admin?
    role == 'admin'
  end

  def project_manager?
    role == 'project_manager'
  end

  searchkick highlight: [:name, :email, :role]

  def search_data
    {
      name: name,
      email: email,
      role: role.name
    }
  end

  private

  def generate_invitation_token
    self.invitation_token = SecureRandom.hex(10) if invitation_token.blank?
  end

  def password_required?
    new_record? || password.present?
  end
end

# Ensure the index is created
User.reindex
