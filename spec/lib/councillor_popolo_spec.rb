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

  describe ".update_popolo_for_state" do
    let(:mock_csv_path) {  "spec/fixtures/local_councillors.csv" }
    let(:mock_json_path) { "spec/fixtures/local_councillor_popolo.json" }

    before do
      allow(CouncillorPopolo).to receive(:csv_path_for_state).with("test").and_return mock_csv_path
      allow(CouncillorPopolo).to receive(:json_path_for_state).with("test").and_return mock_json_path
    end

    after { File.delete mock_json_path }

    it "generates a Popolo json file with councillors from the csv" do
      CouncillorPopolo.update_popolo_for_state("test")

      resulting_json = JSON.parse(
        File.read(CouncillorPopolo.json_path_for_state("test"))
      )
      expect(resulting_json["persons"].first["name"]).to eql "Julia Chessell"
    end
  end

  describe ".json_path_for_state" do
    subject { CouncillorPopolo.json_path_for_state("nsw") }

    it { is_expected.to eql "data/NSW/local_councillor_popolo.json" }
  end

  describe ".csv_path_for_state" do
    subject { CouncillorPopolo.csv_path_for_state("nsw") }

    it { is_expected.to eql "data/NSW/local_councillors.csv" }
  end
end
