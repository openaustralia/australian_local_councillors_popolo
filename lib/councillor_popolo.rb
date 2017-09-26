require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

AUSTRALIAN_STATES = ["act","nsw", "nt", "qld", "sa", "tas", "vic", "wa"]

class CouncillorDataProcessor
  def initialize(state:)
    @state = state
  end

  def update_popolo_for_state
    if state_csv_valid?
      json = JSON.pretty_generate(Popolo::CSV.new(csv_path_for_state).data)

      File.open(json_path_for_state, "w") { |f| f << json }
    else
      raise "There are multiple rows with the same id in #{csv_path_for_state}"
    end
  end

  def state_csv_valid?
    duplicate_councillor_ids_in_state_csv.none?
  end

  def duplicate_councillor_ids_in_state_csv
    csv = CSV.read(csv_path_for_state, headers: :first_row)

    csv.values_at("id").flatten.select do |id|
      id unless csv.values_at("id").flatten.one? {|id2| id.eql? id2}
    end.uniq
  end

  def json_path_for_state
    "data/#{@state.upcase}/local_councillor_popolo.json"
  end

  def csv_path_for_state
    "data/#{@state.upcase}/local_councillors.csv"
  end
end
