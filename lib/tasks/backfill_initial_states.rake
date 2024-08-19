namespace :db do
  desc 'Set the initail states for the existing organizations'
  task backfill_states: :environment do
    Organization.find_each do |organization|
      if organization.states.empty?
        organization.add_initial_states_and_transitions
      end
    end
  end
end