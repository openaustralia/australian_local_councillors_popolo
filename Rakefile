require_relative "lib/councillor_popolo"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc "Update data from CSV files in data folder for all states"
task :update_all do
  CouncillorPopolo::AUSTRALIAN_STATES.each do |state|
    puts "Updating #{state.upcase} popolo data"
    CouncillorPopolo::Processor.new(state: state).update_popolo_for_state
  end
end

desc "Update data from CSV files in data folder for a specific state: #{CouncillorPopolo::AUSTRALIAN_STATES.join(", ")}"
task :update, [:state] do |t, args|
  state = args.state.to_sym

  puts "Updating #{state.upcase} popolo data"
  CouncillorPopolo::Processor.new(state: state).update_popolo_for_state
end
