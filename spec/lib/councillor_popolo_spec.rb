require('./lib/councillor_popolo')
STATES = ["act","nsw", "nt", "qld", "sa", "tas", "vic", "wa"]

describe CouncillorPopolo do
  # Check that there's no unexpected hanging changes
  it "all changes in data/**/*.csv files have been generated into Popolo JSON" do
    STATES.each do |state|
      csv = CouncillorPopolo.csv_path_for_state(state)
      json_from_csv_file = JSON.pretty_generate(
        Popolo::CSV.new(csv).data
      )

      expect(json_from_csv_file).to eql File.read(
        CouncillorPopolo.json_path_for_state(state)
      )
    end
  end
end
