class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project
  load_and_authorize_resource :issue, through: :project
  load_and_authorize_resource :comment, through: :issue

  def index
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      comment_params
      @comment = Comment.create(content: comment_params[:content])

      if comment_params[:files]
        @comment.files.attach(comment_params[:files])
      end
      IssueHistory.create( user_id: current_user.id, issue_id: @issue.id, comment_id: @comment.id,  created_at: Time.now, updated_at: Time.now )

    end
    flash[:alert] = @comment.errors.full_messages_for(:content).first
    redirect_to project_issue_path(@issue.project_id, @issue )
  end

  def destroy
    @comment.destroy
    redirect_to project_issue_path(@issue.project_id, @issue )
  end


  private 
  def comment_params
    params.require(:comment).permit(:content, :files)
  end
end
