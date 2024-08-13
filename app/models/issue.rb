class Issue < ApplicationRecord
  belongs_to :project, class_name: 'Project', foreign_key: 'project_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  acts_as_tenant :organization

  has_many :issue_histories, dependent: :destroy
  has_many_attached :files, dependent: :destroy

  has_many :comments, through: :issue_histories, dependent: :destroy

  validates :title, presence: true
  validates :title, length: { minimum: 3 }, if: -> { title.present? }
  validates :title, uniqueness: true

  validates :description, presence: true
  validates :description, length: { minimum: 10 }, if: -> { description.present? } 

  validates :project_id, presence: true
  validates :complexity_point, inclusion: { in: 0..5, message: "must be between 0 and 5" }

  include AASM

  aasm column: 'state' do
    # after_all_transitions :notify_resolved

    state :new, initial: true
    state :in_progress
    state :resolved
    state :closed  

    event :start do
      transitions from: [:new, :resolved], to: :in_progress
    end

    event :resolved  do
      transitions from: :in_progress, to: :resolved, after: :notify_resolved
    end

    event :close do
      transitions from: [:new, :resolved], to: :closed
    end

    event :reopen do
      transitions from: :closed, to: :in_progress
    end
  end

  after_update :track_changes

  searchkick highlight: [:title, :description, :state]

  def search_data
    {
      title: title,
      description: description,
      state: state
    }
  end

  private

  def track_changes
    saved_changes.each do |field, values|
      next if field == 'updated_at' # Skip the updated_at field

      old_value, new_value = values
      field_change = FieldChange.create(
        field: field,
        old_value: old_value,
        new_value: new_value,
        organization_id: organization.id
      )

      IssueHistory.create(
        issue: self,
        user: self.assignee, # or the user who made the change
        organization: self.organization,
        field_change: field_change,
        created_at: Time.current
      )
    end
  end

  def notify_resolved
    if(self.project.project_manager)
      NotifierMailer.issue_mark_as_resoleved(self.title, self.project.project_manager.email).deliver_now
    end
  end
end

Issue.reindex
