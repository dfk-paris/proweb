class Proweb::AttributeKind < ActiveRecord::Base

  has_many :translations, :class_name => '::Proweb::AttributeKindTranslation'

  has_many :pw_attributes, :class_name => '::Proweb::Attribute'

  def name
    translations.first.name
  end

end