require_relative "lib/councillor_popolo"

task default: [:update_all]

desc "Update data from CSV files in data folder for all states"
task :update_all do
  AUSTRALIAN_STATES.each do |state|
    CouncillorDataProcessor.new(state: state).update_popolo_for_state
  end
end

desc "Update data from CSV files in data folder for a specific state: #{AUSTRALIAN_STATES.join(", ")}"
task :update, [:state] do |t, args|
  state = args.state.to_sym

  CouncillorDataProcessor.new(state: state).update_popolo_for_state
end
