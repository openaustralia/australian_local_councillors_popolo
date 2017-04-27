require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

# This is the CSV export URL for our Google Sheet we're using to crownsource data:
# https://docs.google.com/spreadsheets/d/1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE/
GOOGLE_SHEETS_EXPORT_BASE_URL = "https://docs.google.com/spreadsheets/d/1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE/export?format=csv&gid="

# All states/territories in Australia, with the corresponding Google Sheet GID
STATES_WITH_GID = {
  act: "1407971836",
  nsw: "1381284966",
  nt: "1871107520",
  qld: "1123099005",
  sa: "1014301438",
  tas: "49585049",
  vic: "1648378623",
  wa: "1847969170"
}

# GID represents the sheet ID in the workbook. You can get it by looking at the URL
def google_sheets_export_url(gid)
  GOOGLE_SHEETS_EXPORT_BASE_URL + gid
end

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
