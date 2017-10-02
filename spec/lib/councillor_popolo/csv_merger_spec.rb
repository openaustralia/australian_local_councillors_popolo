require('./lib/councillor_popolo')

describe CouncillorPopolo::CSVMerger do
  it "won't initialize without a master_csv_path" do
    expect { CouncillorPopolo::CSVMerger.new(changes_csv_path: "file.csv") }.
      to raise_error(ArgumentError, "missing keyword: master_csv_path")
  end

  it "won't initialize without a changes_csv_path" do
    expect { CouncillorPopolo::CSVMerger.new(master_csv_path: "file.csv") }.
      to raise_error(ArgumentError, "missing keyword: changes_csv_path")
  end

  describe ".merge" do
    let(:master_csv_path) { "./spec/fixtures/local_councillors_master.csv" }
    let(:changes_csv_path) { "./spec/fixtures/local_councillors_changes.csv" }
    let(:csv_headers) { ["name", "start_date", "end_date", "executive", "council", "council_website", "id", "email", "image", "party", "source", "ward"] }
    let(:pre_existing_councillor_row) { ["Julia Chessell", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/julia_chessell", "jches@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/julia.jpg", "Independent", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", ""] }
    let(:henare) { ["Henare Degan", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/henare_degan", "hdegan@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/henare.jpg", "Party Party Party", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", ""] }
    let(:hisayo) { ["Hisayo Horie", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/hisayo_horie", "hhorie@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/hisayo.jpg", "Make Toronto Nice Party", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", ""] }
    let(:new_councillor_rows) do
      [ henare, hisayo ]
    end

    before do
      CSV.open(master_csv_path, "w") do |csv|
        csv << csv_headers
        csv << pre_existing_councillor_row
      end

      CSV.open(changes_csv_path, "w") do |csv|
        csv << csv_headers
        new_councillor_rows.each do |row|
          csv << row
        end
      end
    end

    after do
      File.delete(master_csv_path)
      File.delete(changes_csv_path)
    end

    it "validates the changes CSV" do
      merger = CouncillorPopolo::CSVMerger.new(
        master_csv_path: master_csv_path,
        changes_csv_path: changes_csv_path
      )

      expect(merger).to receive(:changes_csv_valid?)

      merger.merge
    end

    context "when the current CSV does not contain councillors with ids of the councillors to be incorporated" do
      it "doesn't alter the existing councillor rows" do
        CouncillorPopolo::CSVMerger.new(
          master_csv_path: master_csv_path,
          changes_csv_path: changes_csv_path
        ).merge

        expect(CSV.read(master_csv_path, headers: true).first.fields).to eql(
          pre_existing_councillor_row
        )
      end

      it "appends them to the file" do
        CouncillorPopolo::CSVMerger.new(
          master_csv_path: master_csv_path,
          changes_csv_path: changes_csv_path
        ).merge

        expect(CSV.read(master_csv_path, headers: true).to_a).to eql [
          csv_headers,
          pre_existing_councillor_row,
          henare,
          hisayo
        ]
      end
    end

    context "when the current CSV contains councillors with ids of the councillors to be incorporated" do
      let(:pre_existing_henare_row) { ["Henare Degan", "2010-09-01", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/henare_degan", "", "", "", "", ""] }
      let(:expected_henare_row) { ["Henare Degan", "2010-09-01", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/henare_degan", "hdegan@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/henare.jpg", "Party Party Party", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", ""] }
      let(:row_with_change_to_pre_existing_councillor) { ["Julia Chessell", "", "2017-09-28", "", "Foo City Council", "", "foo_city_council/julia_chessell", "", "", "", "", ""] }
      let(:expected_updated_pre_existing_councillor) { ["Julia Chessell", "", "2017-09-28", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/julia_chessell", "jches@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/julia.jpg", "Independent", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", ""] }

      before do
        CSV.open(master_csv_path, "a+", headers: true) do |master_csv|
          master_csv << pre_existing_henare_row
        end

        CSV.open(changes_csv_path, "a+", headers: true) do |changes_csv|
          changes_csv << row_with_change_to_pre_existing_councillor
        end
      end

      it "incorporates the changes into the existing row for those councillors" do
        CouncillorPopolo::CSVMerger.new(
          master_csv_path: master_csv_path,
          changes_csv_path: changes_csv_path
        ).merge

        expect(CSV.read(master_csv_path, headers: true).to_a).to eql [
          csv_headers,
          expected_updated_pre_existing_councillor,
          expected_henare_row,
          hisayo
        ]
      end
    end
  end

  # FIXME: You should be able to confirm the validator is being run
  #        without using expect_any_instance_of. This is a code smell.
  describe "#changes_csv_valid?" do
    let(:changes_path) { "./spec/fixtures/changes.csv" }

    before do
      CSV.open(changes_path, "w") do |csv|
        csv << ["row"]
      end
    end

    after { File.delete(changes_path) }

    it "runs the changes csv through the validator" do
      expect_any_instance_of(CouncillorPopolo::CSVValidator).to receive(:validate)

      CouncillorPopolo::CSVMerger.new(
        master_csv_path: "master/path",
        changes_csv_path: changes_path
      ).changes_csv_valid?
    end
  end
end
