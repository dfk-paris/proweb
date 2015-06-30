class Proweb::Object < ActiveRecord::Base

  belongs_to :project

  has_many :translations, :class_name => '::Proweb::ObjectTranslation'

  belongs_to :journal, :class_name => '::Proweb::Attribute'
  belongs_to :volume, :class_name => '::Proweb::Attribute'
  belongs_to :issuer, :class_name => '::Proweb::Attribute'
  belongs_to :category, :class_name => '::Proweb::Attribute'
  belongs_to :kind, :class_name => '::Proweb::Attribute', :foreign_key => :object_type_id

  has_many :object_attributes, :class_name => '::Proweb::ObjectAttribute'
  has_many :pw_attributes, :class_name => '::Proweb::Attribute', :through => :object_attributes

  has_many :object_people, :class_name => '::Proweb::ObjectPerson'
  has_many :people, :class_name => '::Proweb::Person', :through => :object_people
  
  has_many :authors, -> { where("objects_people.kind_id IN (?)", [12063, 13267]) },
    class_name: '::Proweb::Person',
    through: :object_people,
    source: :person

  def created_by
    self[:created_by] || begin
      mapping = {
        "js" => "jsissia",
        "cf" => "cfritzsch",
        "mb" => "mbremer",
        "ap" => "apanek",
        "kk" => "kkosciuczuk"
      }
      key = comment ? comment.split(/[\n\r]+/).first.downcase : nil
      mapping[key]
    end
  end

  def people_by_role_ids
    result = {}
    object_people.includes(:person).each do |op|
      result[op.kind_id] ||= []
      result[op.kind_id] << op.person
    end
    result
  end

  def country
    if oa = object_attributes.find{|a| a.kind_id == 168}
      oa.pw_attribute
    end
  end

  def city
    if oa = object_attributes.find{|a| a.kind_id == 175}
      oa.pw_attribute
    end
  end

  def tags
    object_attributes.to_a.select{|oa| oa.kind_id == 43}.map do |oa|
      oa.pw_attribute
    end.select{|pw| pw.present?}
  end  

  def files
    base_dir = "/home/schepp/Desktop/mws/projects/proweb/own_reality_link_tree"
    dir = "#{base_dir}/#{id}"
    return [] unless File.exists?(dir)

    real_dir = File.readlink(dir)
    Dir["#{real_dir}/*"].reject{|f| f.match(/Zeige Objekt \d+\.lnk/)}.map do |f|
      result = f
      result.gsub! '/home/schepp/Desktop/mws/projects/proweb/own_reality_files', 'K:\ProWeb\Doks\Ownreality'
      result.gsub '/', "\\"
    end
  end

end