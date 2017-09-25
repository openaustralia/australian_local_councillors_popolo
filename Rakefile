require_relative "lib/councillor_popolo"

STATES = ["act","nsw", "nt", "qld", "sa", "tas", "vic", "wa"]

task default: [:update_all]

desc "Update data from CSV files in data folder for all states"
task :update_all do
  STATES.each do |state|
    CouncillorPopolo.new(state: state).update_popolo_for_state
  end
end

desc "Update data from CSV files in data folder for a specific state: #{STATES.join(", ")}"
task :update, [:state] do |t, args|
  state = args.state.to_sym

  CouncillorPopolo.new(state: state).update_popolo_for_state
end
