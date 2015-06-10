class Proweb::Person < ActiveRecord::Base

  has_many :objects_people, :class_name => "::Proweb::ObjectPerson", :foreign_key => "object_id"
  has_many :objects, :through => :objects_people

  def display_name
    # [last_name, first_name, email].select{|f| f.present?}.join(',')
    self[:display_name].
      gsub(/\s*\(\d+\)\s*$/, '').
      gsub(/Anonyme,/, "Anonyme")
  end

end
