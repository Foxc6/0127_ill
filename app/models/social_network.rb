class SocialNetwork < ActiveRecord::Base
  has_many :social_reaches
  has_many :contacts, through: :social_reaches
  has_attached_file :logo_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo_image, content_type: /\Aimage\/.*\Z/
  attr_accessor :delete_logo_image
  before_validation { self.logo_image.clear if self.delete_logo_image == '1' }
end