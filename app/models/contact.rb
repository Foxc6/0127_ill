class Contact < ActiveRecord::Base
  self.per_page = 20
  CONTACT_COMPANY_TYPE_ID = 32


  acts_as_taggable # Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on (define taggable on)
  belongs_to :contact_type
  belongs_to :locale
  belongs_to :self_expression_type
  belongs_to :time_zone
  belongs_to :directional_motivation
  belongs_to :company_contact, :class_name => :Contact,:foreign_key => "company_contact_id"
  has_many :sale_contacts
  has_many :referral_contacts
  has_many :projects, through: :sale_contacts
  has_many :projects, through: :referral_contacts
  has_many :project_contacts
  has_many :projects, through: :project_contacts
  has_many :project_team_members
  has_many :projects, through: :project_team_members

  has_many(:user_connections, :source => :user_connections, :foreign_key => :connector_id, :dependent => :destroy)

  has_many :connections, :through => :user_connections, :source => :connectie

  has_many :recievers
  has_many :payment_schedules, through: :recievers
  has_many :activities, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :phone_numbers, :dependent => :destroy, :inverse_of => :contact
  has_many :emails, :dependent => :destroy, :inverse_of => :contact
  has_many :addresses, :dependent => :destroy
  has_many :social_reaches, :dependent => :destroy
  has_many :website_urls, :dependent => :destroy, :inverse_of => :contact
  has_many :contact_skills, :dependent => :destroy, :inverse_of => :contact
  has_many :social_networks, through: :social_reaches
  # TODO  this breaks rails admin, correct the relationship
  has_many :client_contacts, :dependent => :destroy, :inverse_of => :contact

  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => true
  accepts_nested_attributes_for :social_reaches, :allow_destroy => true
  accepts_nested_attributes_for :website_urls, :allow_destroy => true
  accepts_nested_attributes_for :contact_skills, :allow_destroy => true
  accepts_nested_attributes_for :projects, :allow_destroy => true
  accepts_nested_attributes_for :client_contacts, :allow_destroy => true
  accepts_nested_attributes_for :user_connections, :allow_destroy => true


  validates :contact_type, presence: true
  validates_length_of :slug, :maximum => 3
  validates_uniqueness_of :slug, :allow_blank => true

  has_attached_file :profile_image, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
  attr_accessor :delete_profile_image
  before_validation { self.profile_image.clear if self.delete_profile_image == '1' }
  before_save :upcase_slug
  validates :email, email: true, allow_blank: true

  after_create :assign_locale
  after_create :assign_tag_name

  rails_admin do
    object_label_method :full_name
  end

  belongs_to :contact_type
  belongs_to :locale
  belongs_to :self_expression_type
  belongs_to :time_zone
  belongs_to :directional_motivation
  belongs_to :company_contact, :class_name => :Contact,:foreign_key => "company_contact_id"

  # searchable do
  #   text :first_name
  #   text :last_name
  #   text :contact_type do
  #     contact_type.name if contact_type
  #   end
  #   text :self_expression_type do
  #     self_expression_type.name if self_expression_type
  #   end
  #   text :directional_motivation do
  #     directional_motivation.name if directional_motivation
  #   end
  #   text :company_contact do
  #     company_contact.full_name if company_contact
  #   end
  # end

  def profile_img_from_url(url)
    self.profile_image = URI.parse(url)
  end

  def to_param
    if self.contact_type.present? && self.contact_type.id == CONTACT_COMPANY_TYPE_ID
      if self.slug.present?
        "#{slug}"
      else
        "#{id}"
      end
    else
    "#{id}"
    end
  end

  def full_name
    if self.contact_type.present?
      if self.contact_type.id == CONTACT_COMPANY_TYPE_ID
        return self.company_name
      else
      "#{self.first_name} #{self.last_name}"
      end
    else
    end
  end

  def company_contacts
    company_contacts = []
    if self.client_contacts.any?
      self.client_contacts.each do |cc|
        contact = Contact.find(cc.client_id)
        company_contacts.push(contact)
      end
    end
    contacts = Contact.where(:company_contact_id => self.id).full_name_order_scope
    company_contacts.push(contacts)
    company_contacts.flatten!.uniq!
    company_contacts
  end

  def projects_count
    @project_count = Project.where('client_contact_id = ? or agency_client_contact_id = ?', self.id, self.id).order('project_number ASC').count
  end

  def abbr_name
    "#{self.first_name} #{self.last_name.chars.first}."
  end

  def self.search(search)
    where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR about LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end

  def self.user_scope
    where(locale_id: Rails.application.config.user_locale_id)
  end

  def self.people_scope
    where.not(contact_type_id: CONTACT_COMPANY_TYPE_ID)
  end

  def self.active_people_not_team_scope
    joins(:projects).where.not(contact_type_id: CONTACT_COMPANY_TYPE_ID).where(is_team: false)
  end

  def self.people_not_team_scope
    where.not(contact_type_id: CONTACT_COMPANY_TYPE_ID).where(is_team: false)
  end

  def self.company_scope
    where(contact_type_id: CONTACT_COMPANY_TYPE_ID)
  end

  def self.company_not_client_scope
    where(contact_type_id: CONTACT_COMPANY_TYPE_ID).where(is_client: false)
  end

  def self.client_scope
    where(is_client: true)
  end

  def self.team_scope
    where(is_team: true)
  end

  def self.general_scope
    where(is_client: false)
  end

  def self.full_name_order_scope(direction = 'asc')
    if direction.present?
      order("COALESCE(NULLIF(last_name, ''), NULLIF(company_name, ''), NULLIF(first_name, '')) #{direction}, COALESCE(NULLIF(company_name, ''), NULLIF(first_name, '')) #{direction}, NULLIF(first_name, '')")
    else
      order("COALESCE(NULLIF(last_name, ''), NULLIF(company_name, ''), NULLIF(first_name, '')) ASC, COALESCE(NULLIF(company_name, ''), NULLIF(first_name, '')) ASC, NULLIF(first_name, '')")
    end
  end

  def client_projects
    Project.where(:client_contact_id => self.id).order('project_number DESC')
  end

  def client_paid_invoice_total
    payments = []
    client_projects.each do |project|
      sum = project.payment_schedules.where.not('received_date' =>  nil).sum(:total)
      payments.push(sum.to_int)
    end
    payments.sum
  end

  def team_projects
    ProjectTeamMember.where(:contact_id => self.id).order('project_number DESC')
  end

  def upcase_slug
    if self.slug
      self.slug = self.slug.upcase
    end
  end

  # Social Convenience methods
  def twitter
    twitter_id = SocialNetwork.where({name:'Twitter'}).first.id
    self.social_reaches.where(social_network_id: twitter_id).first
  end

  private

  def assign_locale
    self.locale_id = Rails.application.config.user_locale_id
    self.save!
  end

  def assign_tag_name
    if self.contact_type.name == 'Company'
      name = self.company_name
      name = name.gsub(/\W+/, ' ')
      name = name.split("_")[0]
      name = name.split[0]
      name = name.gsub(/[^0-9a-z ]/i, '')
      self.tag_name = name
      self.instance_variable_set "@#{name}", name
    else
      name = self.full_name.gsub(" ", "_")
      name = name.gsub(/[^0-9a-z ]/i, '')
      self.tag_name = name
      self.instance_variable_set "@#{name}", name
    end
  end

end
