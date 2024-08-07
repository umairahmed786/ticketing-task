class Issue < ApplicationRecord
  belongs_to :project
  belongs_to :assignee
  acts_as_tenant :organization
end
