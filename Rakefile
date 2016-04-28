require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

# TODO: Update data for all states

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

desc "Updates NSW data from the spreadsheet"
task :update_nsw do
  update_data(:nsw, google_sheets_export_url("1381284966"))
end
