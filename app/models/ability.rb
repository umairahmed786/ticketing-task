class Ability
  include CanCan::Ability

  def initialize(user)
    if user.owner?
      can :manage, :all
    elsif user.admin?
      can :manage, :all
      cannot :destroy, Comment, user: { role: { name: 'owner' } }
    elsif user.project_manager?
      can %i[read update create], User
      can %i[read add_user remove_user], Project, project_manager_id: user.id
      can :read, Project, users: { id: user.id }
      can :manage, Issue, project: { project_manager_id: user.id }
      can :read, Issue, project: { users: { id: user.id } }
      can :manage, Comment
      cannot :destroy, Comment, user: { role: { name: %w[owner admin] } }
    elsif user.general_user?
      can %i[read update], User, id: user.id
      can :read, Project, users: { id: user.id }
      can :manage, Comment, issue_history: { user_id: user.id }
      can :read, Issue, project: { users: { id: user.id } }
      can :update, Issue, [:state], assignee_id: user.id
    end
  end
end
