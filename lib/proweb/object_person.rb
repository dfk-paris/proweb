class Proweb::ObjectPerson < ActiveRecord::Base

  self.table_name = "objects_people"

  belongs_to :object, :foreign_key => "objekt_id"
  belongs_to :person, :foreign_key => "person_id"

  belongs_to :kind, :class_name => "::Proweb::Attribute"

end