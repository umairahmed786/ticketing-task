class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role.name == 'owner'
      can :manage, :all
    elsif user.role.name == 'admin'
      can :manage, :all 
    elsif user.role.name == 'project_manager'
      can :manage, Project, project_manager: user.id
      can :mange, Issue do|issue|
        issue.project_id.project_manager == user.id
      end
      can :manage, Comment
    else
      can :manage, Comment
      can :manage, Issue do |issue|
        issue.assignee_id == user.id
      end
    end
  end
end
