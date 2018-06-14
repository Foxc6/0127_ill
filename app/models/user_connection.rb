class UserConnection < ActiveRecord::Base
  belongs_to :connector, class_name: "Contact", :foreign_key => "connector_id"
  belongs_to :connectie, class_name: "Contact", :foreign_key => "connectie_id"

  validates :name, presence: true
  validates :connectie_id, presence: true
end
