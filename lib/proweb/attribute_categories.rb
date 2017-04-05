require 'spreadsheet'

class Proweb::AttributeCategories

  def initialize(url)
    @url = url
    parse
  end

  def parse
    data = Proweb.http_client.get_content(@url)
    book = ::Spreadsheet.open(StringIO.new(data))
    @data = xls_to_hash(book.worksheets.first)
  end

  def for_attribute_id(id)
    (lookup[id.to_i] || {})['category_1']
  end

  def lookup
    @lookup ||= begin
      result = {}
      @data.each{|d| result[d['attribute_id'].to_i] = d}
      result
    end
  end

  def xls_to_hash(sheet)
    records = []
    sheet.each 1 do |row|
      headers = sheet.first.to_a
      record = {}
      headers.each_with_index do |h, i|
        value = row[i]
        value = value.value if value.respond_to?(:value)
        record[h] = value
      end
      records << record if record.values.any?{|v| !!v}
    end
    records
  end

end