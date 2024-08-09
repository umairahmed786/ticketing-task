class IssuesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :issue, through: :project

  def index
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

  private

  def issue_params
    params.require(:issue).permit(:title, :description, :assignee_id, :complexity_point, :state)
  end
end
