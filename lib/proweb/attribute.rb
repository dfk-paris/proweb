class Proweb::Attribute < ActiveRecord::Base

  belongs_to :kind, :class_name => '::Proweb::AttributeKind'

  has_many :translations, :class_name => '::Proweb::AttributeTranslation'

  has_many :object_attributes, :class_name => '::Proweb::ObjectAttribute'
  has_many :objects, :class_name => '::Proweb::Object', :through => :object_attributes

end