class IssuesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project
  load_and_authorize_resource :issue, through: :project
  

  before_action :set_users, only: %i[new edit update create] 
  before_action :set_states, only: %i[edit update create] 



  def index
    @issues = @project.issues.includes(:assignee, :project).paginate(page: params[:page], per_page: 10)
  end

  def new
    @available_states = @issue.aasm.states.select { |s| s.options[:initial] == true }.map(&:name)
  end

  def create
    @issue = Issue.new(issue_params.merge(project_id: params[:project_id]))
    if @issue.save
      redirect_to project_issues_path
    else
      @available_states = @issue.aasm.states.select { |s| s.options[:initial] == true }.map(&:name)
      render :new
    end
  end

  def show
    @issue_histories = @issue.issue_histories.includes(:user, :field_change, :comment).order(created_at: :desc).paginate(page: params[:histories_card], per_page: 10)
    @issue_comments = @issue.comments.order(created_at: :desc).paginate(page: params[:comments_card], per_page: 10)
    @issue_files = @issue.files.order(created_at: :desc).paginate(page: params[:files_card], per_page: 10)
  end

  def edit
  end

  def update
    @issue.assign_attributes(issue_params.except(:state))
    if @issue.state != issue_params[:state]
      trigger_state_event(issue_params[:state])
      redirect_to project_issue_path(@issue.project_id, @issue)
    elsif @issue.save
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
        new_file_ids = @issue.files.last(params[:files].size).pluck(:id) if attachments
        new_file_ids.each do |file_id|
          IssueHistory.create!(
            user_id: current_user.id,
            issue_id: @issue.id,
            active_storage_attachment_id: file_id,
            created_at: Time.now,
            updated_at: Time.now
          )
        end
      end
    redirect_to project_issue_path(@issue.project_id, @issue)
    end
  end

  private

  def issue_params
    params.require(:issue).permit(:title, :description, :assignee_id, :complexity_point, :state)
  end

  def trigger_state_event(new_state)
    event_method = "#{ new_state }!"

    if @issue.respond_to?(event_method)
      @issue.send( event_method )
    end 
  end

  def set_states
    @available_states = [@issue.state] + @issue.aasm.states(permitted: true).map(&:name).map(&:to_s)
  end

  def set_users
    @project_users = @project.project_users
    @project_users = @project_users.map {|project_user| project_user.user}
    @project_users += [@project.project_manager, @project.admin].compact
  end
end
