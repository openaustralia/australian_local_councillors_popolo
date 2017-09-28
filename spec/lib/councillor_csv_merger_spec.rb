require('./lib/councillor_csv_merger')
describe CouncillorCSVMerger do
  let(:master_csv_path) { "./spec/fixtures/local_councillors_master.csv" }
  let(:changes_csv_path) { "./spec/fixtures/local_councillors_changes.csv" }
  let(:csv_headers) { ["name", "start_date", "end_date", "executive", "council", "council website", "id", "email", "image", "party", "source", "ward", "phone_mobile"] }
  let(:pre_existing_councillor_row) { ["Julia Chessell", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/julia_chessell", "jches@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/julia.jpg", "Independent", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", "", ""] }
  let(:new_councillor_rows) do
    [
      ["Henare Degan", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/henare_degan", "hdegan@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/henare.jpg", "Party Party Party", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", "", ""],
      ["Hisayo Horie", "", "", "", "Foo City Council", "http://www.foo.nsw.gov.au", "foo_city_council/hisayo_horie", "hhorie@foocity.nsw.gov.au", "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/hisayo.jpg", "Make Toronto Nice Party", "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors", "", ""]
    ]
  end

  before do
    CSV.open(master_csv_path, "w") do |csv|
      csv << csv_headers
      csv << pre_existing_councillor_row
    end

    CSV.open(changes_csv_path, "w") do |csv|
      csv << ["name", "start_date", "end_date", "executive", "council", "council website", "id", "email", "image", "party", "source", "ward", "phone_mobile"]
      new_councillor_rows.each do |row|
        csv << row
      end
    end
  end

  after do
    File.delete(master_csv_path)
    File.delete(changes_csv_path)
  end

  it "won't initialize without a master_csv_path" do
    expect { CouncillorCSVMerger.new(changes_csv_path: changes_csv_path) }.
      to raise_error(ArgumentError, "missing keyword: master_csv_path")
  end

  it "won't initialize without a changes_csv_path" do
    expect { CouncillorCSVMerger.new(master_csv_path: master_csv_path) }.
      to raise_error(ArgumentError, "missing keyword: changes_csv_path")
  end


  describe ".merge" do
    context "when the current CSV does not contain councillors with ids of the councillors to be incorporated" do
      it "doesn't alter the existing councillor rows" do
        CouncillorCSVMerger.new(
          master_csv_path: master_csv_path,
          changes_csv_path: changes_csv_path
        ).merge

        expect(CSV.read(master_csv_path, headers: true).first.fields).to eql(
          pre_existing_councillor_row
        )
      end

      it "appends them to the file" do
        CouncillorCSVMerger.new(
          master_csv_path: master_csv_path,
          changes_csv_path: changes_csv_path
        ).merge

        expect(CSV.read(master_csv_path, headers: true).to_a).to eql [
          csv_headers,
          pre_existing_councillor_row,
          new_councillor_rows[0],
          new_councillor_rows[1]
        ]
      end
    end

    context "when the current CSV contains councillors with ids of the councillors to be incorporated" do
      before do
        CSV.open(master_csv_path, "a+", headers: true) do |master_csv|
            master_csv << [
              "Henare Degan",
              "",
              "",
              "",
              "Foo City Council",
              "http://www.foo.nsw.gov.au",
              "foo_city_council/henare_degan",
              "",
              "",
              "",
              "",
              "",
              ""
            ]
        end
      end

      pending "incorporates the changes into the existing row for those councillors" do
        CouncillorCSVMerger.new(
          master_csv_path: master_csv_path,
          changes_csv_path: changes_csv_path
        ).merge

        expect(CSV.read(master_csv_path, headers: true)[1].fields).to eql [
          "Henare Degan",
          "",
          "",
          "",
          "Foo City Council",
          "http://www.foo.nsw.gov.au",
          "foo_city_council/henare_degan",
          "hdegan@foocity.nsw.gov.au",
          "http://www.foo.nsw.gov.au/__data/assets/image/0018/11547/henare.jpg",
          "Party Party Party",
          "http://www.foo.nsw.gov.au/inside-foo/about-council/councillors",
          "",
          ""
        ]
      end
    end

    context "when the CSV headers don't match" do
      before do
        CSV.open(changes_csv_path, "r+", headers: true) do |changes_csv|
          changes_csv.read.headers << "additional header"
        end
      end

      subject { CouncillorCSVMerger.new(master_csv_path: master_csv_path, changes_csv_path: changes_csv_path) }

      pending "raises an error" do
        expect{ subject.merge }.to raise_error
      end
    end
  end
end
