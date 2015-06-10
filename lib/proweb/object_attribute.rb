class Proweb::ObjectAttribute < ActiveRecord::Base

  belongs_to :object
  belongs_to :pw_attribute, :class_name => "::Proweb::Attribute", :foreign_key => 'attribute_id'

end