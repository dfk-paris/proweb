class Proweb::Attribute < ActiveRecord::Base

  belongs_to :kind, :class_name => '::Proweb::AttributeKind', :foreign_key => :attribute_kind_id

  has_many :translations, :class_name => '::Proweb::AttributeTranslation'

  has_many :object_attributes, :class_name => '::Proweb::ObjectAttribute'
  has_many :objects, :class_name => '::Proweb::Object', :through => :object_attributes

  def name
    translations.first.name
  end

end