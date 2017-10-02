module CouncillorPopolo
  # Raise when there's two of the same councillors in a file
  class DuplicateCouncillorsError < RuntimeError ; end

  # Raise when headers of files to be merged don't match
  class HeaderMismatchError < RuntimeError ; end

  # Raise when the headers of a CSV are non-standard
  class NonStandardHeadersError < RuntimeError ; end
end

