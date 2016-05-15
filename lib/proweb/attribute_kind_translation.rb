class Proweb::AttributeKindTranslation < ActiveRecord::Base

  belongs_to :language, :foreign_key => "language_id"

end