class Proweb::ProjectAttribute < ActiveRecord::Base

  self.table_name = :projects_attributes

  belongs_to :project, :class_name => '::Proweb::Project', :foreign_key => :project_id
  belongs_to :pw_attribute, :class_name => '::Proweb::Attribute', :foreign_key => :attribute_id

end