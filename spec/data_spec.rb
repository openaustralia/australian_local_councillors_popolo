require('./lib/councillor_popolo')

describe "Each State CSV file" do
  it "is valid" do
    CouncillorPopolo::AUSTRALIAN_STATES.each do |state|
      CouncillorPopolo::Processor.new(state: state).state_csv_valid?
    end
  end

  # Check that there's no unexpected hanging changes
  it "has had all changes generated into Popolo JSON with `bundle exec rake update_all`" do
    CouncillorPopolo::AUSTRALIAN_STATES.each do |state|
      processor = CouncillorPopolo::Processor.new(state: state)
      json_from_csv_file = JSON.pretty_generate(
        Popolo::CSV.new(processor.csv_path_for_state).data
      )

      expect(json_from_csv_file).to eql File.read(
        processor.json_path_for_state
      )
    end
  end
end
