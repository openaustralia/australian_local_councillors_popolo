require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

# TODO: Update data for all states

desc "Updates NSW data from the spreadsheet"
task :update_nsw do
  google_sheets_export_url_nsw = "https://docs.google.com/feeds/download/spreadsheets/Export?key=1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE&exportFormat=csv&gid=1381284966"
  Tempfile.open("nsw_councillor_csv") do |f|
    f << open(google_sheets_export_url_nsw).read
    json = JSON.pretty_generate(Popolo::CSV.new(f).data)
    File.open("nsw_local_councillor_popolo.json", "w") { |f| f << json }
  end
end
