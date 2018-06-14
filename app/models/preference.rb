class Preference < ActiveRecord::Base

  validates :name, presence: true
  validates :company, presence: true
  validates :url, presence: true
  validates :mail_from_address, presence: true

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
  attr_accessor :delete_logo
  before_validation { self.logo.clear if self.delete_logo == '1' }

  before_create :ensure_default_exists_and_is_unique

  scope :by_url, lambda { |url| where("url like ?", "%#{url}%") }

  def self.current(domain = nil)
    current_preference = domain ? Preference.by_url(domain).first : nil
    current_preference || Preference.default
  end

  def self.default
    where(default: true).first || new
  end

  private

  def ensure_default_exists_and_is_unique
    if default
      Preference.update_all(default: false)
    else
      self.default = true
    end
  end

end
