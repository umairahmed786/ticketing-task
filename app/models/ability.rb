class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role.name == 'owner'
      can :manage, :all
    elsif user.role.name == 'admin'
      can :manage, :all
    elsif user.role.name == 'project_manager'
      can %i[read update create], User
      can %i[read add_user remove_user], Project, project_manager_id: user.id
      can :manage, Issue do |issue|
        issue.project.project_manager_id == user.id
      end
      can :manage, Comment
    elsif user.role.name == 'general_user'
      can %i[read update], User, id: user.id
      can :read, Project, users: { id: user.id }
      can :manage, Comment
      can :read, Issue do |issue|
        issue.project.users.include?(user)
      end
      can :update, Issue, [:state] do |issue|
        issue.project.users.include?(user)
      end
    end
  end
end
