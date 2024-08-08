class IssueHistory < ApplicationRecord
  belongs_to :field_change, optional: true
  # belongs_to :attachment, class: 'ActiveStorageAttachment', optional: true
  belongs_to :comment, optional: true
  belongs_to :issue
  belongs_to :user
  acts_as_tenant :organization

  has_one_attached :attachment
end
