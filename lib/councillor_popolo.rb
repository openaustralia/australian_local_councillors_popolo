require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

class CouncillorPopolo
  def self.update_popolo_for_state(state)
    puts "Reading #{csv_path_for_state(state)}"
    json = JSON.pretty_generate(Popolo::CSV.new(csv_path_for_state(state)).data)

    puts "Writing #{json_path_for_state(state)}"
    File.open(json_path_for_state(state), "w") { |f| f << json }
  end

  def self.json_path_for_state(state)
    "data/#{state.upcase}/local_councillor_popolo.json"
  end

  def self.csv_path_for_state(state)
    "data/#{state.upcase}/local_councillors.csv"
  end
end
