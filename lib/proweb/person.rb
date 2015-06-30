class Proweb::Person < ActiveRecord::Base

  has_many :objects_people, :class_name => "::Proweb::ObjectPerson", :foreign_key => "object_id"
  has_many :objects, :through => :objects_people

  def first_name
    self[:first_name] ||= begin
      result = display_name.split(/\s*,\s*/).last
      result == "Anonyme" ? nil : result
    end
  end

  def last_name
    display_name.split(/\s*,\s*/).first
  end

  def display_name
    # [last_name, first_name, email].select{|f| f.present?}.join(',')
    self[:display_name].
      gsub(/,?\s*\(\d+\)\s*$/, '').
      gsub(/Anonyme,/, "Anonyme")
  end

end
