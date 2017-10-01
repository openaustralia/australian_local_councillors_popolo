require('csv')

module CouncillorPopolo
  class CSVMerger
    def initialize(master_csv_path:, changes_csv_path:)
      @master_csv_path = master_csv_path
      @changes_csv_path = changes_csv_path
    end

    def merge
      # create a new csv to write to
      new_csv_string = CSV.generate do |output_master_csv|
        master_csv = CSV.read(@master_csv_path, headers: true)
        changes_csv = CSV.read(@changes_csv_path, headers: true)

        output_master_csv << master_csv.headers

        # for every row in the existing master csv
        master_csv.each do |input_master_csv_row|
          #   if the row has the same id as a row in the changes csv, merge them
          if changes_csv.values_at("id").flatten.include?(input_master_csv_row["id"])
            new_matching_row = changes_csv.find {|row| row["id"].eql?(input_master_csv_row["id"])}

            input_master_csv_row.each do |key, value|
              input_master_csv_row[key] = new_matching_row[key] unless new_matching_row[key].empty?
            end

            # Remove the row
            changes_csv.delete_if {|row| row["id"].eql?(input_master_csv_row["id"])}
          end

          output_master_csv << input_master_csv_row
        end

        # append all remaining rows from changes to the master csv
        changes_csv.each do |changes_row|
          output_master_csv << changes_row
        end
      end

      # overwrite the existing file
      File.open(@master_csv_path, "w") {|file| file.write(new_csv_string ) }
    end

    def changes_csv_valid?
      master_csv_headers = CSV.read(@master_csv_path, headers: true).headers

      CSV.read(@changes_csv_path, headers: true).headers.eql? master_csv_headers
    end
  end
end
