class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact, :inverse_of => :activities
  belongs_to :activity_type
  belongs_to :activity_object
  belongs_to :locale
  belongs_to :project
  has_many :file_attachments, :dependent => :destroy

  validates :user, presence: true
  validates :contact, presence: true
  validates :activity_type, presence: true
  validates :activity_object, presence: true
  after_create :assign_locale

  def user_name
  	self.user.abbr_name
  end

  def contact_name
		"#{self.contact.first_name} #{self.contact.last_name.chars.first}."
  end

  def self.search(search)
    where("note LIKE ?", "%#{search}%")
  end

  scope :locale, lambda { |user|
    where(:user).where("locale_id = ?", user.locale_id)
  }

  def locale
    self.user.locale
  end

  def self.user_scope
    where(locale_id: Rails.application.config.user_locale_id)
  end

  private

  def assign_locale
    self.locale_id = Rails.application.config.user_locale_id
    self.save!
  end
end

