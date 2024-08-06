class IssueHistory < ApplicationRecord
  belongs_to :fieldChange
  belongs_to :attachment
  belongs_to :comment
  belongs_to :issue
  belongs_to :user
  acts_as_tenant :organization
end
