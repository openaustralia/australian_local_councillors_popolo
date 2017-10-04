require('csv')
require('rest-client')

module CouncillorPopolo
  class CSVMerger
    attr_reader :master_csv_path
    attr_reader :changes_csv_path

    # TODO: You should probably be able to call this on the object.
    def self.merge_from_remote_csv(master_csv_path:, changes_csv_url:)
      Dir.mkdir("./tmp") unless Dir.exists?("./tmp")

      request = RestClient.get(changes_csv_url)
      file_name = request.headers[:content_disposition].split('"').last

      local_changes_file = File.open("./tmp/#{file_name}", "w") do |f|
        f << request.body
      end

      self.new(
        master_csv_path: master_csv_path,
        changes_csv_path: local_changes_file.path
      ).merge

      nil if File.delete(local_changes_file.path)
    end

    def initialize(master_csv_path:, changes_csv_path:)
      @master_csv_path = master_csv_path
      @changes_csv_path = changes_csv_path
    end

    def merge
      if changes_csv_valid?
        # create a new csv to write to
        new_csv_string = CSV.generate do |output_master_csv|
          master_csv = CSV.read(master_csv_path, headers: true)
          changes_csv = CSV.read(changes_csv_path, headers: true)

          output_master_csv << master_csv.headers

          # for every row in the existing master csv
          master_csv.each do |input_master_csv_row|
            #   if the row has the same id as a row in the changes csv, merge them
            if changes_csv.values_at("id").flatten.include?(input_master_csv_row["id"])
              new_matching_row = changes_csv.find {|row| row["id"].eql?(input_master_csv_row["id"])}

              input_master_csv_row.each do |key, value|
                unless new_matching_row[key].nil? || new_matching_row[key].empty?
                  input_master_csv_row[key] = new_matching_row[key]
                end
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
        nil if File.open(master_csv_path, "w") {|file| file.write(new_csv_string ) }
      end
    end

    def changes_csv_valid?
      CouncillorPopolo::CSVValidator.new(changes_csv_path).validate
    end
  end
end
