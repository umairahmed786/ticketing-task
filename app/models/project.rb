class Project < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :project_manager, class_name: 'User', foreign_key: 'project_manager_id'
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :project_manager, presence: true
  validates :admin, presence: true
end
