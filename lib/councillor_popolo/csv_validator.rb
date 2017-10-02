module CouncillorPopolo
  class CSVValidator
    STANDARD_HEADERS = [
      "name",
      "start_date",
      "end_date",
      "executive",
      "council",
      "council website",
      "id",
      "email",
      "image",
      "party",
      "source",
      "ward"
    ]

    def self.validate(csv)
      if csv.headers.eql? STANDARD_HEADERS
        true
      else
        error_message = "CSV has non standard headers #{csv.headers}, should be #{STANDARD_HEADERS}"
        raise NonStandardHeadersError, error_message
      end
    end

    def self.validate_from_path(path)
      self.validate(CSV.read(path, headers: true))
    end

    def self.duplicate_councillor_ids_in_csv(csv)
      ids = []

      if csv.values_at("id").count != csv.values_at("id").uniq.count
        ids = csv.values_at("id").flatten.select do |id|
          id unless csv.values_at("id").flatten.one? {|id2| id.eql? id2}
        end.uniq
      end

      ids
    end
  end
end
