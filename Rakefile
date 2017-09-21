require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

STATES = ["act","nsw", "nt", "qld", "sa", "tas", "vic", "wa"]

def update_data(state)
  json_filename = "#{state.to_s}_local_councillor_popolo.json"
  csv_filename = "data/#{state.upcase}/#{state}_local_councillors.csv"

  puts "Fetching #{state.to_s.upcase} CSV: #{csv_filename}"
  file = File.read(csv_filename)
  json = JSON.pretty_generate(Popolo::CSV.new(csv_filename).data)
  puts "Saving: #{json_filename}"
  File.open(json_filename, "w") { |f| f << json }
end

task default: [:update_all]

desc "Update data from CSV files in data folder for all states"
task :update_all do
  STATES.each do |state|
    update_data(state)
  end
end

desc "Update data from CSV files in data folder for a specific state: #{STATES.join(", ")}"
task :update, [:state] do |t, args|
  state = args.state.to_sym

  update_data(state)
end
