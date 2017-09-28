require('csv')

class CouncillorCSVMerger
  def self.merge(master_file_path, changes_file_path)
    CSV.open(master_file_path, "a+", headers: true) do |master_csv|
      CSV.read(changes_file_path, "r", headers: true).each do |changes_row|
        master_csv << changes_row
      end
    end
  end
end
