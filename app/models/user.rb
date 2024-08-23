require 'elasticsearch/model'
class User < ApplicationRecord
  acts_as_tenant :organization
  sequenceid :organization, :users
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :confirmable

  attr_accessor :organization_name

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :issue_histories, dependent: :destroy

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
  before_destroy :nullify_project_manager, :nullify_assignee

  def self.current
    Thread.current[:current_user]
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def admin?
    role.name == 'admin'
  end

  def project_manager?
    role.name == 'project_manager'
  end

  def general_user?
    role.name == 'general_user'
  end

  def self.admins
    where(role_id: Role.find_by_name('admin').id)
  end

  searchkick highlight: %i[name email role]

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

  def nullify_project_manager
    Project.where(project_manager_id: id).update_all(project_manager_id: nil)
  end

  def nullify_assignee
    Issue.where(assignee_id: id).update_all(assignee_id: nil)
  end
end

# Ensure the index is created
User.reindex
