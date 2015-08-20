class Proweb::AttributeKlass < ActiveRecord::Base

  has_many :kinds, :class_name => "::Proweb::AttributeKind", :foreign_key => :attribute_klass_id
  
end