require "proweb/version"

PROWEB_ROOT = File.expand_path(File.dirname(__FILE__) + '/..')

require 'active_record'
require 'yaml'
require 'pathname'
require 'sequel'
require 'logger'
require 'pry'
require 'sqlite3'
require 'httpclient'
require 'progressbar'

$: << "#{PROWEB_ROOT}/lib"

module Proweb

  autoload :ObjectAttribute, "proweb/object_attribute"
  autoload :AttributeCategories, 'proweb/attribute_categories'
  autoload :AttributeKind, "proweb/attribute_kind"
  autoload :AttributeKindTranslation, "proweb/attribute_kind_translation"
  autoload :AttributeKlass, "proweb/attribute_klass"
  autoload :AttributeTranslation, "proweb/attribute_translation"
  autoload :Categories, "proweb/categories"
  autoload :FileCleaner, "proweb/file_cleaner"
  autoload :Project, "proweb/project"
  autoload :Object, "proweb/object"
  autoload :Attribute, "proweb/attribute"
  autoload :Language, "proweb/language"
  autoload :Person, "proweb/person"
  autoload :ObjectPerson, "proweb/object_person"
  autoload :ObjectText, "proweb/object_text"
  autoload :ObjectTranslation, "proweb/object_translation"
  autoload :ProjectTranslation, "proweb/project_translation"
  autoload :ProjectAttribute, "proweb/project_attribute"
  autoload :Import, 'proweb/import'
  autoload :OldDataMerger, 'proweb/old_data_merger'

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
    require 'sqlite3'
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

  def self.http_client
    @http_client ||= HTTPClient.new
  end

  def self.progress_bar(options = {})
    options.reverse_merge! :format => "%t |%B| %c/%C (+%R/s) | %a |%f"
    ProgressBar.create options
  end

end
