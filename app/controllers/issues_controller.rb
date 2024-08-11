class IssuesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :issue, through: :project

  def index
    @issues = @issues.includes(:assignee, :project).paginate(page: params[:page], per_page: 10)
  end

  def new
  end

  def create
    @issue = Issue.new(issue_params.merge(project_id: params[:project_id]))
    if @issue.save
      redirect_to project_issues_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @issue.update(issue_params)
      redirect_to project_issue_path(@issue.project_id, @issue)
    else
      render :edit
    end
  end

  def destroy
    @issue.destroy
    redirect_to project_issues_path
  end

  def attach_file
    if params[:files].present?
      ActiveRecord::Base.transaction do
        attachments = @issue.files.attach(params[:files])
        new_file_ids = @issue.files.last(params[:files].size).pluck(:id) if @issue.files.attached?
        issue_histories = new_file_ids.map { |file_id|
          { user_id: current_user.id, issue_id: @issue.id, active_storage_attachment_id: file_id , created_at: Time.now, updated_at: Time.now }
        }
        IssueHistory.insert_all(issue_histories)        
      end
    redirect_to project_issue_path(@issue.project_id, @issue)
    end
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :description, :assignee_id, :complexity_point, :state)
  end
end
