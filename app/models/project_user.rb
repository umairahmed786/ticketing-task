class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user
  acts_as_tenant :organization
end
