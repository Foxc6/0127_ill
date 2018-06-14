class PhoneNumber < ActiveRecord::Base
  belongs_to :contact

  validates :name, presence: true
  validates :number, presence: true
end
