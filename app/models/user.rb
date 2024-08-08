class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  acts_as_tenant :organization

  belongs_to :role, class_name: 'Role', foreign_key: 'role_id'

  def mark_as_confirmed
    self.confirmation_token = nil
    self.confirmed_at = Time.now
  end
  before_create :generate_invitation_token

  private

  def generate_invitation_token
    self.invitation_token = SecureRandom.hex(10) if invitation_token.blank?
  end
end
