class TaskType < ActiveRecord::Base
  has_many :tasks
  belongs_to :locale

	validates :name, presence: true

  has_attached_file :icon_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :icon_image, content_type: /\Aimage\/.*\Z/
  attr_accessor :delete_icon_image
  before_validation { self.icon_image.clear if self.delete_icon_image == '1' }

  after_create :assign_locale

  def self.user_scope
    where(locale_id: Rails.application.config.user_locale_id)
  end

  def fa_icon
  	icon = ''

  	if self.name == 'Send'
  		icon = 'gift'
  	elsif self.name == 'Email'
  		icon = 'envelope'
  	elsif self.name == 'Call'
  		icon = 'phone'
  	elsif self.name == 'Invite'
  		icon = 'user-plus'
  	elsif self.name == 'RFP'
  		icon = 'file'
  	end
  	icon
  end

  scope :locale, lambda { |user|
    joins(:user).where("locale_id = ?", user.locale_id)
  }

  private

  def assign_locale
    self.locale_id = Rails.application.config.user_locale_id
    self.save!
  end
end
