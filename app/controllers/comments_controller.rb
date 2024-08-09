class CommentsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :issue, through: :project
  load_and_authorize_resource :comment, through: :issue

  def index
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @comment = Comment.create(content: params[:content])
      IssueHistory.create( user_id: current_user.id, issue_id: @issue.id, comment_id: @comment.id , created_at: Time.now, updated_at: Time.now )

    end
    redirect_to project_issue_path(@issue.project_id, @issue)
  end


  private 
  def comment_params
    params.permit(:content)
  end
end
