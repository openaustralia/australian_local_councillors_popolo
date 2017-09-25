require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

class CouncillorPopolo
  def self.update_popolo_for_state(state)
    json_filename = "data/#{state.upcase}/local_councillor_popolo.json"
    csv_filename = "data/#{state.upcase}/local_councillors.csv"

    puts "Fetching #{state.to_s.upcase} CSV: #{csv_filename}"
    json = JSON.pretty_generate(Popolo::CSV.new(csv_filename).data)
    puts "Saving: #{json_filename}"
    File.open(json_filename, "w") { |f| f << json }
  end
end
