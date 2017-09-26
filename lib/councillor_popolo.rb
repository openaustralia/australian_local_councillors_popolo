require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

class CouncillorDataProcessor
  def initialize(state:)
    @state = state
  end

  def update_popolo_for_state
    puts "Reading #{csv_path_for_state}"
    json = JSON.pretty_generate(Popolo::CSV.new(csv_path_for_state).data)

    puts "Writing #{json_path_for_state}"
    File.open(json_path_for_state, "w") { |f| f << json }
  end

  def json_path_for_state
    "data/#{@state.upcase}/local_councillor_popolo.json"
  end

  def csv_path_for_state
    "data/#{@state.upcase}/local_councillors.csv"
  end
end
