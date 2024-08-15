class Project < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :project_manager, class_name: 'User', foreign_key: 'project_manager_id', optional: true 
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  has_many :issues, dependent: :destroy


  validates :title, presence: true 
  validates :title, length: { minimum: 3 }, if: -> { title.present? }
  validates_uniqueness_to_tenant :title

  validates :description, presence: true
  validates :description, length: { minimum: 10 }, if: -> { description.present? } 

  # validates :project_manager, presence: true, if: -> { project_manager_id.present? } 
  validates :admin, presence: true

  searchkick highlight: [:title, :description, :project_manager]

  def search_data
    {
      title: title,
      description: description,
      project_manager: project_manager&.name
    }
  end
end

Project.reindex
