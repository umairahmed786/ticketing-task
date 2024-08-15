class SearchController < ApplicationController
  before_action :authenticate_user!
  def index
    @query = params[:query]
    if @query.blank?
      redirect_to dashboards_path
      return
    end

    @users = User.search(
      @query,
      highlight: {
        tag: "<strong style='background-color: yellow;'>",
        fragment_size: 150,
        number_of_fragments: 3
      }
    ) if current_user.role.name == ('owner' || 'admin')

    @issues = Issue.search(
      @query, highlight: {
        tag: '<strong style="background-color: yellow;">',
        fragment_size: 150,
        number_of_fragments: 3
      }
    ) if can? :read, Issue

    @projects = Project.search(
      @query, highlight: {
        tag: '<strong style="background-color: yellow;">',
        fragment_size: 150,
        number_of_fragments: 3
      }
    ) if can? :read, Project
  end
end
