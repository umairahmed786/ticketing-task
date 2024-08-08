class Issue < ApplicationRecord
  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  acts_as_tenant :organization

  has_many :issue_histories
  has_many_attached :files

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :assignee_id, presence: true
  validates :project_id, presence: true
  validates :complexity_point, inclusion: { in: 0..5, message: "must be between 0 and 5" }
  validates :state, inclusion: { in: ["New", "In Progress", "Resolved"], message: "%{value} is not a valid state" }
end
