require "spreadsheet"

class Proweb::Categories

  def self.from_file
    book = ::Spreadsheet.open(Proweb.config['attribute_categories_file'])
    sheet = book.worksheets.first

    headers = sheet.first.to_a

    records = []
    sheet.each 1 do |row|
      record = {}
      headers.each_with_index do |h, i|
        value = row[i]
        value = value.value if value.respond_to?(:value)
        record[h] = value
      end
      records << record
    end

    lookup_data = {}
    cat_hash = {}

    records.each do |r|
      category = r['category']
      category = "Institutionen" if category.match(/^Institutionen/)
      category = "Ausstellungen" if category.match(/^Ausstellungen/)
      category = "Gruppen & Tendenzen" if category.match(/^Gruppen&Tendenzen/)
      category = "Länder" if category.match(/^Länder/)
      category = "Medien" if category.match(/^Medien/)
      category = "Sonstiges" if category == "??"
      r['category'] = category
      cat_hash[category] = true
      lookup_data[r['attribute_id']] = r
    end

    new(lookup_data, cat_hash.keys)
  end

  def initialize(data = {}, list = [])
    @data = data
    @list = list
  end

  def by_id(id)
    @data[id]
  end

  def list
    @list
  end

  def folded_list
    list.map{|c| fold_cat c}.uniq
  end

  def fold_cat(str = "")
    return nil if str.blank?
    str.underscore.gsub(/[\/ \&_äöüÄÖÜ]+/, "")
  end

end