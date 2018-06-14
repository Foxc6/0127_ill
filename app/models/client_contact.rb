class ClientContact < ActiveRecord::Base
  belongs_to :client, class_name: "Contact", :foreign_key => "client_id"
  belongs_to :contact

  validates :contact_id, presence: true
  validates :client_id, presence: true
  validates :name, presence: true
end
