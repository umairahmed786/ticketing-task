class Project < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :project_manager, class_name: 'User', foreign_key: 'project_manager_id'
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
end
