class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact
  belongs_to :task_type
  belongs_to :project

  validates :user, presence: true
  #validates :description, presence: true
  validates :contact, presence: true
  validates :task_type, presence: true

  after_create :assign_locale

  def self.user_scope
    where(locale_id: Rails.application.config.user_locale_id)
  end

  def user_name
  	self.user.abbr_name
  end

  def contact_name
		"#{self.contact.first_name} #{self.contact.last_name.chars.first}."
  end

	def self.search(search)
    where("description LIKE ?", "%#{search}%")
  end

  scope :locale, lambda { |user|
    where(:user).where("locale_id = ?", user.locale_id)
  }

  def locale
    self.user.locale
  end

  private

  def assign_locale
    self.locale_id = Rails.application.config.user_locale_id
    self.save!
  end
end
