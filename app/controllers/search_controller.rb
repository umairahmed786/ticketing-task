class SearchController < ApplicationController
  def index
    @query = params[:query]
    @users = User.search(@query, highlight: {
                           tag: '<strong style="background-color: yellow;">',
                           fragment_size: 150,
                           number_of_fragments: 3
                         })
    @issues = Issue.search(@query, highlight: {
                           tag: '<strong style="background-color: yellow;">',
                           fragment_size: 150,
                           number_of_fragments: 3
                         })
    @projects = Project.search(@query, highlight: {
                                tag: '<strong style="background-color: yellow;">',
                                fragment_size: 150,
                                number_of_fragments: 3
                              })
  end
end
