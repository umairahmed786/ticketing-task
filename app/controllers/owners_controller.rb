class OwnersController < ApplicationController
  def index
    @projects = @organization.projects
  end
end
