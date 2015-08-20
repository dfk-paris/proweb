class Proweb::AttributeKind < ActiveRecord::Base

  has_many :translations, :class_name => '::Proweb::AttributeKindTranslation'

  has_many :pw_attributes, :class_name => '::Proweb::Attribute'

  belongs_to :klass, :class_name => '::Proweb::AttributeKlass', :foreign_key => :attribute_klass_id

  def name
    translations.first.name
  end

end