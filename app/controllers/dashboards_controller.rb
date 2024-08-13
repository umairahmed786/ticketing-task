class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
      @available_from_states = State.all
      @available_to_states = State.where.not( initial: true )
  end

  def add_custom_state
    state_name = custom_state_params[:state_name]
    from_states = custom_state_params[:from_state].reject(&:blank?)
    to_states = custom_state_params[:to_state].reject(&:blank?)
    is_initial = custom_state_params[:initial_state]
    # binding.pry
    if state_name.present? && (is_initial == "1" ?  from_states.blank? && to_states.present? : from_states.present?)
      ActiveRecord::Base.transaction do
        @state = State.create(name: state_name, initial: is_initial)

        if @state.persisted?
          @transition = Transition.create(
            event_name: @state.name,
            to_state_id: @state.id,
            notify: custom_state_params[:notify] == '0'
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
                existing_transition = Transition.find_by(id: to_state_id)
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
