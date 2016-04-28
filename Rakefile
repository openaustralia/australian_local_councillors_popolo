require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

# TODO: Update data for all states

def update_data(state, url)
  Tempfile.open("councillor_csv") do |file|
    file << open(url).read
    json = JSON.pretty_generate(Popolo::CSV.new(file).data)
    File.open("#{state.to_s}_local_councillor_popolo.json", "w") { |f| f << json }
  end
end

desc "Updates NSW data from the spreadsheet"
task :update_nsw do
  update_data(:nsw, "https://docs.google.com/feeds/download/spreadsheets/Export?key=1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE&exportFormat=csv&gid=1381284966")
end
