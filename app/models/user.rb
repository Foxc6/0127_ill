class User < ActiveRecord::Base
  belongs_to :locale
  has_many :activities
  has_many :tasks
  belongs_to :role

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role_id, presence: true
  validates :email, presence: true
  validates :locale, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  attr_accessor :delete_avatar
  before_validation { self.avatar.clear if self.delete_avatar == '1' }

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def abbr_name
    "#{self.first_name} #{self.last_name.chars.first}."
  end

end