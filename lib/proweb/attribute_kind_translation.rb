class Proweb::AttributeKindTranslation < ActiveRecord::Base

  belongs_to :language, :foreign_key => "spracheid"

end