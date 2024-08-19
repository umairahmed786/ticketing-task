namespace :db do
  desc 'Set the initail states for the existing organizations'
  task backfill_states: :environment do
    Organization.includes(:states).where(states: { id: nil }).each do |organization|
      organization.add_initial_states_and_transitions
    end
  end
end