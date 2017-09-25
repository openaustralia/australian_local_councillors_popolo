require('./lib/councillor_popolo')
STATES = ["act","nsw", "nt", "qld", "sa", "tas", "vic", "wa"]

describe CouncillorPopolo do
  # Check that there's no unexpected hanging changes
  it "all changes in data/**/*.csv files have been generated into Popolo JSON" do
    STATES.each do |state|
      existing_generated_json = "data/#{state.upcase}/local_councillor_popolo.json"
      csv_filename = "data/#{state.upcase}/local_councillors.csv"
      file = File.read(csv_filename)
      json_from_csv_files = JSON.pretty_generate(Popolo::CSV.new(csv_filename).data)
      expect(json_from_csv_files).to eql File.read(existing_generated_json)
    end
  end
end
