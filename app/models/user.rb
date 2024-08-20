require 'elasticsearch/model'
class User < ApplicationRecord
  acts_as_tenant :organization
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :confirmable

  attr_accessor :organization_name

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users, dependent: :destroy

  belongs_to :role, class_name: 'Role', foreign_key: 'role_id'
  validates :name, presence: true

  validates :email, presence: true,
                    uniqueness: { scope: :organization_id, case_sensitive: false },
                    format: { with: Devise.email_regexp }
  # Password validations
  validates :password, presence: true,
                       confirmation: true, length: { within: 6..128 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def mark_as_confirmed
    self.confirmation_token = nil
    self.confirmed_at = Time.now
  end
  before_create :generate_invitation_token
  before_save :update_organization_name, if: :organization_name_changed?

  def admin?
    role.name == 'admin'
  end

  def project_manager?
    role.name == 'project_manager'
  end

  def owner?
    role.name == 'owner'
  end

  def general_user?
    role.name == 'general_user'
  end

  searchkick highlight: %i[name email role]

  def search_data
    {
      name: name,
      email: email,
      role: role&.name
    }
  end

  private

  def generate_invitation_token
    self.invitation_token = SecureRandom.hex(10) if invitation_token.blank?
  end

  def password_required?
    new_record? || password.present?
  end

  def update_organization_name
    organization.update(name: organization_name)
  end

  def organization_name_changed?
    organization_name.present? && organization.name != organization_name
  end
end

# Ensure the index is created
User.reindex
