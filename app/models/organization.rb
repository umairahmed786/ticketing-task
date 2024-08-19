class Organization < ApplicationRecord
  has_many :users
  has_many :projects
  has_many :project_users
  validates :name, :subdomain, presence: true, uniqueness: true
  has_many :states
  validates :subdomain, format: {
    with: /\A(?=.*[a-zA-Z])[a-zA-Z0-9]+\z/,
    message: 'must only contain alphabets and numbers, and must include at least one alphabet.'
  }

  after_create :add_initial_states_and_transitions


  def add_initial_states_and_transitions
    # Initial States
    new = State.create( name: 'new', initial: true, organization_id: self.id )
    in_progress = State.create( name: 'in_progress', initial: false, organization_id: self.id )    
    resolved = State.create( name: 'resolved', initial: false, organization_id: self.id )    
    close = State.create( name: 'close', initial: false, organization_id: self.id )
    
    # Initial Transitions
    new_transition = Transition.create(event_name: new.name, to_state_id: new.id, notify: false, organization_id: self.id)
    in_progress_transition = Transition.create(event_name: in_progress.name, notify: false, to_state_id: in_progress.id, organization_id: self.id)
    resolved_transition = Transition.create(event_name: resolved.name, notify: true, to_state_id: resolved.id, organization_id: self.id)
    close_transition = Transition.create(event_name: close.name, to_state_id: close.id, notify: false, organization_id: self.id)

    # From to Inprogress event
    in_progress_transition.from_transitions.create(state: new, organization_id: self.id)
    in_progress_transition.from_transitions.create(state: resolved, organization_id: self.id)
    in_progress_transition.from_transitions.create(state: close, organization_id: self.id)

    # From to resolved
    resolved_transition.from_transitions.create(state: in_progress, organization_id: self.id)


    # From to close
    close_transition.from_transitions.create(state: resolved, organization_id: self.id)
    close_transition.from_transitions.create(state: new, organization_id: self.id)

  end
  
end
