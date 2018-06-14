class Email < ActiveRecord::Base
  belongs_to :contact

  validates :email, presence: true

end
