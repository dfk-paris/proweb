class Proweb::ProjectTranslation < ActiveRecord::Base

  belongs_to :language
  belongs_to :project

end