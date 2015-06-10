require "active_record"

class Proweb::Project < ActiveRecord::Base

  has_many :objects

  has_many :translations, :class_name => '::Proweb::ProjectTranslation'

  has_many :projects_attributes, :class_name =>  '::Proweb::ProjectAttribute'
  has_many :pw_attributes, :class_name => '::Proweb::Attribute', :through => :projects_attributes

  def name
    translations.first.name
  end
  
end