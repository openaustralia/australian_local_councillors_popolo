require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

# This is the CSV export URL for our Google Sheet we're using to crownsource data:
# https://docs.google.com/spreadsheets/d/1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE/
GOOGLE_SHEETS_EXPORT_BASE_URL = "https://docs.google.com/feeds/download/spreadsheets/Export?key=1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE&exportFormat=csv&gid="

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
task update_all: [:update_act, :update_nsw, :update_nt, :update_qld, :update_sa, :update_tas, :update_vic, :update_wa]

desc "Update data from Google Sheet for ACT"
task :update_act do
  update_data(:act, google_sheets_export_url("1407971836"))
end

desc "Update data from Google Sheet for NSW"
task :update_nsw do
  update_data(:nsw, google_sheets_export_url("1381284966"))
end

desc "Update data from Google Sheet for NT"
task :update_nt do
  update_data(:nt, google_sheets_export_url("1871107520"))
end

desc "Update data from Google Sheet for QLD"
task :update_qld do
  update_data(:qld, google_sheets_export_url("1123099005"))
end

desc "Update data from Google Sheet for SA"
task :update_sa do
  update_data(:sa, google_sheets_export_url("1014301438"))
end

desc "Update data from Google Sheet for TAS"
task :update_tas do
  update_data(:tas, google_sheets_export_url("49585049"))
end

desc "Update data from Google Sheet for VIC"
task :update_vic do
  update_data(:vic, google_sheets_export_url("1648378623"))
end

desc "Update data from Google Sheet for WA"
task :update_wa do
  update_data(:wa, google_sheets_export_url("1847969170"))
end
