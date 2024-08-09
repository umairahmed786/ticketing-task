class Project < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :project_manager, class_name: 'User', foreign_key: 'project_manager_id'
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  has_many :issues, dependent: :destroy


  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :project_manager, presence: true
  validates :admin, presence: true
end
