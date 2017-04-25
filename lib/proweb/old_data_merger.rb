require 'spreadsheet'
require 'ruby-progressbar'

class Proweb::OldDataMerger

  def initialize(file, id_field = 'id', keys = [])
    @id_field = id_field
    @file = file
    @keys = keys
    @by_id = {}
    @records = []
    
    parse if File.exists?(@file)
  end

  attr_reader :by_id
  attr_reader :keys
  attr_reader :records

  def parse
    book = ::Spreadsheet.open(@file)

    book.worksheets.each do |sheet|
      progress = Proweb.progress_bar title: "parsing old data", total: sheet.rows.size

      sheet.each 1 do |row|
        headers = sheet.first.to_a
        record = {}
        headers.each_with_index do |h, i|
          value = row[i]
          value = value.value if value.respond_to?(:value)
          record[h] = value
        end

        if record[@id_field].present?
          @records << record
          by_id[record[@id_field]] = record
        end

        progress.increment
      end
      puts
    end

    @records
  end

  def values(id)
    keys.map{|k| @by_id[id] ? @by_id[id][k] : nil}
  end

end