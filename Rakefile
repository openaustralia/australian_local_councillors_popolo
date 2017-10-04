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

desc "Update data for a stat using a remote CSV file by proding its url"
task :update_state_from_remote_csv, [:state, :url] do |t, args|
  state = args.state.to_sym
  url = args.url

  processor = CouncillorPopolo::Processor.new(state: state)

  puts "Requesting CSV from #{url}"
  CouncillorPopolo::CSVMerger.merge_from_remote_csv(
    master_csv_path: processor.csv_path_for_state,
    changes_csv_url: url
  )

  puts "Updating #{state.upcase} popolo data"
  processor.update_popolo_for_state
end
