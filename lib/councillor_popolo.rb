require "tempfile"
require "open-uri"
require "json"
require "csv_to_popolo"

require_relative "councillor_popolo/csv_validator"
require_relative "councillor_popolo/processor"
require_relative "councillor_popolo/csv_merger"
require_relative "councillor_popolo/errors"

module CouncillorPopolo
  AUSTRALIAN_STATES = ["nsw", "qld", "sa", "tas", "vic", "wa"]
end
