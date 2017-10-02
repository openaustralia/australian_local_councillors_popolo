require('./lib/councillor_popolo')

describe CouncillorPopolo::Processor do
  describe "#update_popolo_for_state" do
    let(:mock_csv_path) {  "spec/fixtures/local_councillors.csv" }
    let(:mock_json_path) { "spec/fixtures/local_councillor_popolo.json" }
    let(:processor) { CouncillorPopolo::Processor.new(state: "test") }

    context "when the state csv and json exist" do
      after(:each) { File.delete mock_json_path }

      before do
        allow(processor).to receive(:csv_path_for_state).and_return mock_csv_path
        allow(processor).to receive(:json_path_for_state).and_return mock_json_path
      end

      it "generates a Popolo json file with councillors from the csv" do
        processor.update_popolo_for_state

        resulting_json = JSON.parse(
          File.read(processor.json_path_for_state)
        )
        expect(resulting_json["persons"].first["name"]).to eql "Julia Chessell"
      end
    end

    # TODO: We should really handle creating multiple memberships for a single person.
    #       But that's a bit confusing at the moment for people updating the data.
    #       So for now, each person can only have one membership.
    context "when the CSV contains multiple councillors with the same id" do
      let(:mock_csv_with_dups_path) {  "spec/fixtures/local_councillors_with_duplicate.csv" }

      before :each do
        allow(processor).to receive(:csv_path_for_state).and_return mock_csv_with_dups_path
        allow(processor).to receive(:json_path_for_state).and_return mock_json_path
      end

      it "raises an error" do
        expected_error_message = "There are multiple rows with the id foo_city_council/foo_bar in spec/fixtures/local_councillors_with_duplicate.csv"
        expect { processor.update_popolo_for_state }.to raise_error CouncillorPopolo::DuplicateCouncillorsError, expected_error_message
      end
    end
  end

  # FIXME: You should be able to confirm the validator is being run
  #        without using expect_any_instance_of. This is a code smell.
  describe "#state_csv_valid?" do
    let(:processor) { CouncillorPopolo::Processor.new(state: "test") }
    let(:mock_csv_with_dups_path) {  "spec/fixtures/local_councillors_with_duplicate.csv" }

    before do
      allow(processor).to receive(:csv_path_for_state).and_return mock_csv_with_dups_path
    end

    it "runs the state csv through the validator" do
      expect_any_instance_of(CouncillorPopolo::CSVValidator).to receive(:validate)
      processor.state_csv_valid?
    end
  end

  describe "#duplicate_councillor_ids_in_state_csv" do
    let(:processor) { CouncillorPopolo::Processor.new(state: "test") }

    context "when the CSV contains multiple councillors with the same id" do
      let(:mock_csv_with_dups_path) {  "spec/fixtures/local_councillors_with_duplicate.csv" }

      before do
        allow(processor).to receive(:csv_path_for_state).and_return mock_csv_with_dups_path
      end

      it "it returns the ids" do
        expect(processor.duplicate_councillor_ids_in_state_csv).to eql ["foo_city_council/foo_bar"]
      end
    end

    context "when the CSV does not contains contain multiple councillors with the same id" do
      let(:mock_csv_path) {  "spec/fixtures/local_councillors.csv" }

      before do
        allow(processor).to receive(:csv_path_for_state).and_return mock_csv_path
      end

      it "is empty" do
        expect(processor.duplicate_councillor_ids_in_state_csv).to be_empty
      end
    end
  end

  describe "#json_path_for_state" do
    context "with a string" do
      subject { CouncillorPopolo::Processor.new(state: "foo").json_path_for_state }

      it { is_expected.to eql "data/FOO/local_councillor_popolo.json" }
    end

    context "with a symbol" do
      subject { CouncillorPopolo::Processor.new(state: :foo).json_path_for_state }

      it { is_expected.to eql "data/FOO/local_councillor_popolo.json" }
    end
  end

  describe "#csv_path_for_state" do
    context "with a string" do
      subject { CouncillorPopolo::Processor.new(state: "bar").csv_path_for_state }

      it { is_expected.to eql "data/BAR/local_councillors.csv" }
    end

    context "with a symbol" do
      subject { CouncillorPopolo::Processor.new(state: :bar).csv_path_for_state }

      it { is_expected.to eql "data/BAR/local_councillors.csv" }
    end
  end
end
