class Proweb::ObjectText < ActiveRecord::Base
  belongs_to :object, class_name: '::Probweb::Object'
end