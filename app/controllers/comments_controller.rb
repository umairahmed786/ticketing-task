class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project, find_by: :sequence_num
  load_and_authorize_resource :issue, through: :project, find_by: :sequence_num
  load_and_authorize_resource :comment, through: :issue

  def index
  end

  def show
  end

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @comment = Comment.create!(content: comment_params[:content])
      if comment_params[:files].present?
        @comment.files.attach(comment_params[:files])
      end
      IssueHistory.create!( user_id: current_user.id, issue_id: @issue.id, comment_id: @comment.id,  created_at: Time.current, updated_at: Time.current )

    end
    flash[:error] = @comment.errors.full_messages_for(:content).first if @comment.errors.present?
    redirect_to project_issue_path(@issue.project, @issue)
  end

  def destroy
    @comment.destroy
    redirect_to project_issue_path(@issue.project, @issue)
  end


  private 
  def comment_params
    params.require(:comment).permit(:content, files: [])
  end
end
