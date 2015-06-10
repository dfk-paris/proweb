class Proweb::ObjectTranslation < ActiveRecord::Base

  belongs_to :language
  belongs_to :object

end