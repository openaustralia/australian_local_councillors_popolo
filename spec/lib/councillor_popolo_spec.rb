require('./lib/councillor_popolo')
STATES = ["act","nsw", "nt", "qld", "sa", "tas", "vic", "wa"]

describe CouncillorPopolo do
  # Check that there's no unexpected hanging changes
  it "all changes in data/**/*.csv files have been generated into Popolo JSON, run `bundle exec rake update_all` to generate JSON" do
    STATES.each do |state|
      processor = CouncillorPopolo.new(state: state)
      json_from_csv_file = JSON.pretty_generate(
        Popolo::CSV.new(processor.csv_path_for_state).data
      )

      expect(json_from_csv_file).to eql File.read(
        processor.json_path_for_state
      )
    end
  end

  describe ".update_popolo_for_state" do
    let(:mock_csv_path) {  "spec/fixtures/local_councillors.csv" }
    let(:mock_json_path) { "spec/fixtures/local_councillor_popolo.json" }
    let(:processor) { CouncillorPopolo.new(state: "test") }

    before do
      allow(processor).to receive(:csv_path_for_state).and_return mock_csv_path
      allow(processor).to receive(:json_path_for_state).and_return mock_json_path
    end

    after { File.delete mock_json_path }

    it "generates a Popolo json file with councillors from the csv" do
      processor.update_popolo_for_state

      resulting_json = JSON.parse(
        File.read(processor.json_path_for_state)
      )
      expect(resulting_json["persons"].first["name"]).to eql "Julia Chessell"
    end
  end

  describe ".json_path_for_state" do
    context "with a string" do
      subject { CouncillorPopolo.new(state: "foo").json_path_for_state }

      it { is_expected.to eql "data/FOO/local_councillor_popolo.json" }
    end

    context "with a symbol" do
      subject { CouncillorPopolo.new(state: :foo).json_path_for_state }

      it { is_expected.to eql "data/FOO/local_councillor_popolo.json" }
    end
  end

  describe ".csv_path_for_state" do
    context "with a string" do
      subject { CouncillorPopolo.new(state: "bar").csv_path_for_state }

      it { is_expected.to eql "data/BAR/local_councillors.csv" }
    end

    context "with a symbol" do
      subject { CouncillorPopolo.new(state: :bar).csv_path_for_state }

      it { is_expected.to eql "data/BAR/local_councillors.csv" }
    end
  end
end
