require('./lib/councillor_popolo')

describe CouncillorPopolo::CSVValidator do
  describe ".validate" do
    let(:csv_path) { "./spec/fixtures/local_councillors_master.csv" }
    let(:csv) { CSV.open(csv_path, "w", headers: true) }
    after { File.delete(csv_path) }

    it "calls .has_standard_headers?" do
      expect(CouncillorPopolo::CSVValidator).to receive(:has_standard_headers?).with(csv)
      CouncillorPopolo::CSVValidator.validate(csv)
    end
  end

  describe ".validate_from_path" do
    let(:csv_path) { "./spec/fixtures/local_councillors_master.csv" }
    before { CSV.open(csv_path, "w", headers: true) }
    after { File.delete(csv_path) }

    it "runs .validate on the csv at the path" do
      expected_csv = CSV.read(csv_path, headers: true)
      expect(CouncillorPopolo::CSVValidator).to receive(:validate).with(expected_csv)

      CouncillorPopolo::CSVValidator.validate_from_path(csv_path)
    end
  end

  describe ".has_standard_headers?" do
    let(:henare) { ["Henare Degan", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/henare_degan", "hdegan@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/henare.jpg", "Party Party Party", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", ""] }
    let(:hisayo) { ["Hisayo Horie", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/hisayo_horie", "hhorie@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/hisayo.jpg", "Make Toronto Nice Party", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", ""] }
    let(:new_councillor_rows) do
      [ henare, hisayo ]
    end

    context "when the headers don't match the specified headers" do
      let(:csv_with_bad_headers_path) { "./spec/fixtures/local_councillors_changes_with_bad_headers.csv" }

      before do
        CSV.open(csv_with_bad_headers_path, "w") do |csv|
          csv << ["foo", "bar", "baz", "zapadooo"]
          new_councillor_rows.each do |row|
            csv << row
          end
        end
      end

      after { File.delete(csv_with_bad_headers_path) }

      subject { CouncillorPopolo::CSVValidator.has_standard_headers?(CSV.table(csv_with_bad_headers_path)) }

      it "raises an error" do
        expected_error_message = "CSV has non standard headers [:foo, :bar, :baz, :zapadooo, nil, nil, nil, nil, nil, nil, nil, nil], should be [\"name\", \"start_date\", \"end_date\", \"executive\", \"council\", \"council website\", \"id\", \"email\", \"image\", \"party\", \"source\", \"ward\"]"
        expect { subject }.to raise_error CouncillorPopolo::NonStandardHeadersError, expected_error_message
      end
    end

    context "when the headers match the specified headers" do
      let(:csv_with_standard_headers_path) { "./spec/fixtures/local_councillors_changes.csv" }

      before do
        CSV.open(csv_with_standard_headers_path, "w", headers: true) do |csv|
          csv << ["name", "start_date", "end_date", "executive", "council", "council website", "id", "email", "image", "party", "source", "ward"]
          new_councillor_rows.each do |row|
            csv << row
          end
        end
      end

      after { File.delete(csv_with_standard_headers_path) }

      subject { CouncillorPopolo::CSVValidator.has_standard_headers?(CSV.read(csv_with_standard_headers_path, headers: true)) }
      it { is_expected.to be true }
    end
  end

  describe ".has_unique_councillor_ids" do
    context "when the CSV contains multiple councillors with the same id" do
      let(:mock_csv_with_dup) { CSV.read("spec/fixtures/local_councillors_with_duplicate.csv", headers: true) }

      before do
        allow(CouncillorPopolo::CSVValidator).to(
          receive(:duplicate_councillor_ids_in_csv).with(
            mock_csv_with_dup
          ).and_return ["foo/bar", "baz/fiz"]
        )
      end

      subject { CouncillorPopolo::CSVValidator.has_unique_councillor_ids?(mock_csv_with_dup) }
      it { expect(subject).to be false }
    end

    context "when the CSV does not contains contain multiple councillors with the same id" do
      let(:mock_csv) { CSV.read("spec/fixtures/local_councillors.csv", headers: true) }

      before do
        allow(CouncillorPopolo::CSVValidator).to(
          receive(:duplicate_councillor_ids_in_csv).with(mock_csv).and_return [ ]
        )
      end

      subject { CouncillorPopolo::CSVValidator.has_unique_councillor_ids?(mock_csv) }
      it "is true" do
        expect(subject).to be true
      end
    end
  end

  describe ".duplicate_councillor_ids_in_csv" do
    context "when the CSV contains multiple councillors with the same id" do
      let(:mock_csv_with_dups) { CSV.read("spec/fixtures/local_councillors_with_duplicate.csv", headers: :true) }

      subject do
        CouncillorPopolo::CSVValidator.duplicate_councillor_ids_in_csv(mock_csv_with_dups)
      end

      it "it returns the ids" do
        is_expected.to eql ["foo_city_council/foo_bar"]
      end
    end

    context "when the CSV does not contains contain multiple councillors with the same id" do
      let(:mock_csv) { CSV.read("spec/fixtures/local_councillors.csv", headers: :true) }

      subject { CouncillorPopolo::CSVValidator.duplicate_councillor_ids_in_csv(mock_csv) }
      it "is empty" do
        is_expected.to be_empty
      end
    end
  end
end
