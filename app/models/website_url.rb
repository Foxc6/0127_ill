class WebsiteUrl < ActiveRecord::Base
  belongs_to :contact

  validates :url, presence: true
end
