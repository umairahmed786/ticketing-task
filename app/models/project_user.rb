class ProjectUser < ApplicationRecord
  belongs_to :project, class_name: 'Project'
  belongs_to :user, class_name: 'User'
  acts_as_tenant :organization
end
