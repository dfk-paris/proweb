require "proweb/version"

PROWEB_ROOT = File.expand_path(File.dirname(__FILE__) + '/..')

require "#{PROWEB_ROOT}/lib/patches"

require "active_record"
require "yaml"
require "sequel"
require "logger"
require "byebug"
require "sqlite3"

$: << "#{PROWEB_ROOT}/lib"

module Proweb

  autoload :ObjectAttribute, "proweb/object_attribute"
  autoload :AttributeKind, "proweb/attribute_kind"
  autoload :AttributeKindTranslation, "proweb/attribute_kind_translation"
  autoload :AttributeTranslation, "proweb/attribute_translation"
  autoload :Categories, "proweb/categories"
  autoload :FileCleaner, "proweb/file_cleaner"
  autoload :Project, "proweb/project"
  autoload :Object, "proweb/object"
  autoload :Attribute, "proweb/attribute"
  autoload :Language, "proweb/language"
  autoload :Person, "proweb/person"
  autoload :ObjectPerson, "proweb/object_person"
  autoload :ObjectTranslation, "proweb/object_translation"
  autoload :ProjectTranslation, "proweb/project_translation"
  autoload :ProjectAttribute, "proweb/project_attribute"
  autoload :Import, 'proweb/import'

  def self.root
    PROWEB_ROOT
  end

  def self.config=(config = {})
    @config = config
  end

  def self.config
    @config ||= if File.exists?("config/app.yml")
      YAML.load(File.read "config/app.yml")
    else
      {}
    end
  end

  def self.establish_connection
    ActiveRecord::Base.establish_connection(config["db"]["clean"])
  end

  def self.connect
    establish_connection
    ActiveRecord::Base.connection
  end

  def self.date_to_string(date)
    date.present? ? date.strftime('%Y-%m-%d') : nil
  end

  def self.source
    @source ||= Sequel.connect(config["db"]["source"])
  end

  def self.target
    @target ||= Sequel.connect(config["db"]["target"])
  end

end