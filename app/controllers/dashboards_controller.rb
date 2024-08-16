class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @available_from_states = State.all
    @available_to_states = State.where.not(initial: true)
    @projects = @organization.projects
    @issues_count_by_state = Issue.group(:state).count
    if %w[owner admin].include? current_user.role.name
      @users_count_by_role = User.joins(:role).where(users: { organization_id: @organization.id })
                                 .group('roles.name').count
    end
    @projects_count_by_day = Project.where(projects: { organization_id: @organization.id })
                                    .group_by_day(:created_at, format: '%d %b %Y').count

    if %w[owner admin].include? current_user.role.name
      @users_count_by_day = User.where(users: { organization_id: @organization.id })
                                .group_by_day(:created_at, format: '%d %b %Y').count
    end

    @projects_count_by_day = Project.group_by_day(:created_at, format: '%b %d, %Y').count
    @issues_count_by_day = Issue.group_by_day(:created_at, format: '%b %d, %Y').count
    @comments_count_by_day = Comment.group_by_day(:created_at, format: '%b %d, %Y').count
  end

  def add_custom_state
    state_name = custom_state_params[:state_name]
    if state_name.include?(' ')
      flash[:alert] = 'State name cannot contain spaces.'
      return redirect_to '/dashboards'
    end

    from_states = custom_state_params[:from_state]&.reject(&:blank?)
    to_states = custom_state_params[:to_state]&.reject(&:blank?)
    is_initial = custom_state_params[:initial_state]
    
    if state_name.present? && (is_initial == "1" ?  from_states.blank? && to_states.present? : from_states.present?)
      ActiveRecord::Base.transaction do
        @state = State.create(name: state_name, initial: is_initial)

        if @state.persisted?
          @transition = Transition.create(
            event_name: @state.name,
            to_state_id: @state.id,
            notify: custom_state_params[:notify]
          )

          if @transition.persisted?
            if from_states.present?
              @from_transitions = from_states.map do |from_state_id|
                { state_id: from_state_id, transition_id: @transition.id, created_at: Time.now, updated_at: Time.now }
              end
              FromTransition.insert_all(@from_transitions)
            end

            if to_states.present?
              @to_transitions = to_states.map do |to_state_id|
                existing_transition = Transition.find_by_to_state_id(to_state_id)
                if existing_transition
                  { transition_id: existing_transition.id, state_id: @state.id, created_at: Time.now, updated_at: Time.now }
                end
              end.compact
              FromTransition.insert_all(@to_transitions) 
            end
          end
        end
      end
    else
      flash[:alert] = 'State name and at least one transition (from or to) must be provided.'
    end

    redirect_to '/dashboards'
  end

  private

  def custom_state_params
    params.require(:state).permit(:state_name, :notify, :initial_state, from_state: [], to_state: [] )
  end
end
