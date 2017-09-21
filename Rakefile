require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

STATES = ["act","nsw", "nt", "qld", "sa", "tas", "vic", "wa"]

def update_data(state, url)
  json_filename = "#{state.to_s}_local_councillor_popolo.json"

  Tempfile.open("councillor_csv") do |file|
    puts "Fetching #{state.to_s.upcase} CSV: #{url}"
    file << open(url).read

    json = JSON.pretty_generate(Popolo::CSV.new(file).data)
    puts "Saving: #{json_filename}"
    File.open(json_filename, "w") { |f| f << json }
  end
end

task default: [:update_all]

desc "Update data from Google Sheet for all states"
task :update_all do
  STATES_WITH_GID.each do |state, gid|
    update_data(state, google_sheets_export_url(gid))
  end
end

desc "Update data from Google Sheet for a specific state: #{STATES_WITH_GID.keys.join(", ")}"
task :update, [:state] do |t, args|
  state = args.state.to_sym

  update_data(state, google_sheets_export_url(STATES_WITH_GID[state]))
end
