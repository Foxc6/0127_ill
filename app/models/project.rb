class Project < ActiveRecord::Base

  PROJECT_SALES_STATE_ID = ProjectState.find_by(name: 'Sales').id
  HOT_ID = SaleCaseStatus.find_by(name: "Hot").id
  WARM_ID = SaleCaseStatus.find_by(name: "Warm").id
  COLD_ID = SaleCaseStatus.find_by(name: "Cold").id
  KILLED_ID = SaleCaseStatus.find_by(name: "Killed").id
  ACTIVE_ID = ProjectState.find_by(name: 'Active').id

  # # acts_as_taggable # Alias for acts_as_taggable_on :tags
  # acts_as_taggable_on :tags
  self.per_page = 20
  belongs_to :project_state, touch: true
  belongs_to :project_type, touch: true
  belongs_to :sale_case_status, touch: true
  belongs_to :client, :class_name => :Contact,:foreign_key => "client_contact_id", touch: true
  belongs_to :agency, :class_name => :Contact, :foreign_key => "agency_client_contact_id", touch: true
  belongs_to :sale_contact, :class_name => :Contact,:foreign_key => "sale_contact_id", touch: true
  belongs_to :primary_contact, :class_name => :Contact,:foreign_key => "primary_contact_id", touch: true
  belongs_to :referral_contact, :class_name => :Contact,:foreign_key => "referral_contact_id", touch: true
  belongs_to :team, :class_name => :Contact,:foreign_key => "team_contact_id", touch: true


  has_many :tasks
  has_many :estimates
  has_many :urls
  has_many :activities
  has_many :contacts
  has_many :contacts, :through => :project_contacts
  has_many :project_contacts, :dependent => :destroy, :inverse_of => :project
  has_many :project_team_members, :dependent => :destroy, :inverse_of => :project
  has_many :issues
  has_many :contacts, :through => :referral_contacts
  has_many :referral_contacts
  has_many :sale_contacts
  has_many :payment_schedules, :dependent => :destroy
  has_many :project_images, :dependent => :destroy
  accepts_nested_attributes_for :project_images
  accepts_nested_attributes_for :sale_contacts
  accepts_nested_attributes_for :referral_contacts
  accepts_nested_attributes_for :project_contacts, :allow_destroy => true, :reject_if => :no_contact
  accepts_nested_attributes_for :project_team_members, :allow_destroy => true, :reject_if => :no_contact
  accepts_nested_attributes_for :payment_schedules, :allow_destroy => true
  accepts_nested_attributes_for :urls, :allow_destroy => true

  after_save :create_project_number
  before_update :set_sale_case_status
  before_update :set_was_sale_case
  after_save :create_case_number
  before_save :set_duration
  after_touch :index
  after_save :update_totals



  validates :client, :presence => true

  has_attached_file :thumbnail_image, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/images/:style/briefcase.svg.png"
  validates_attachment_content_type :thumbnail_image, content_type: /\Aimage\/.*\Z/
  has_attached_file :sow_file, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :sow_file, content_type: /\Aimage\/.*\Z/
  attr_accessor :delete_sow_file
  before_validation { self.sow_file.clear if self.delete_sow_file == '1' }

  attr_accessor :delete_thumbnail_image
  before_validation { self.thumbnail_image.clear if self.delete_thumbnail_image == '1' }

  # searchable do
  #   text  :name, :tags, :notes, :url, :project_number, :case_number
  #   text :project_state do
  #     project_state.name if project_state
  #   end
  #   text :client do
  #     client.full_name if client
  #   end
  #   text :project_type do
  #     project_type.name if project_type
  #   end
  #   text :referral_contact do
  #     referral_contact.full_name if referral_contact
  #   end
  #   text :sale_contact do
  #     sale_contact.full_name if sale_contact
  #   end
  #   text :primary_contact do
  #     primary_contact.full_name if primary_contact
  #   end
  #   text :agency do
  #     agency.full_name if agency
  #   end
  #   text :team do
  #     team.full_name if team
  #   end
  #   time  :start_date, :end_date, :created_at, :updated_at
  # end


  def update_totals
    self.update_columns(total: project_total, estimated_total: project_estimated_total)
  end


  def to_param
    if self.project_state.present? && self.project_state.id == PROJECT_SALES_STATE_ID
      if self.case_number.present?
        "#{case_number}"
      else
        "#{project_number}"
      end
    else
    "#{project_number}"
    end
  end

  # TODO there is no contact_id attribute for a project. is this method necessary?
  def no_contact(attributes)
    attributes[:contact_id].blank?
  end

  private

  def set_was_sale_case
    if self.project_state_id == PROJECT_SALES_STATE_ID
      self.was_sale_case = 1
    else
      self.status_updated_at = nil
    end
  end

  def set_sale_case_status
    if self.project_state_id == PROJECT_SALES_STATE_ID
      self.status_updated_at = Time.now
    else
      self.status_updated_at = nil
    end
  end

  def set_duration
    # o get percentage: (day / total_days) * 100
    # to get day: total_days*(percentage/100)
    #   365*(45/100) = day
    #   result: 164.25 days

    sD = self.start_date
    if sD.nil?
      sD = Time.now
    end
    if self.end_date.present?
      eD = self.end_date
    else
      eD = Time.now.end_of_year
    end
    diff = (eD.to_date - sD.to_date).to_i
    self.duration = diff
  end

  def create_case_number
    # if self.project_state.present? && self.project_state.name == "Sales" && self.case_number.blank?
    #   slug = self.client.slug
    #   option = Option.where(:key =>"sales_case_number").first
    #   num = option.value.to_i+1

    #   num_str = get_num_string(num)

    #   self.case_number = "#{num_str}_#{slug}"
    #   self.save

    #   option.value = num
    #   option.save
    # end
    if self.project_state.present? && self.project_state.name == "Sales" && self.case_number.blank?
      digits = 9
      self.case_number ||= loop do
        # Make a random number.
        random = "SC#{Array.new(digits){rand(10)}.join}"
        # Use the random  number if no other order exists with it.
        if self.class.exists?(case_number: random)
          # If over half of all possible options are taken add another digit.
          digits += 1 if self.class.count > (10 ** digits / 2)
        else
          break random
        end
      end

      self.save
    end
  end


  def create_project_number
    if self.project_state.present? && self.project_state.name != "Sales" && self.project_number.blank?
      slug = self.client.slug
      option = Option.where(:key =>"project_number").first
      num = option.value.to_i+1

      num_str = get_num_string(num)

      self.project_number = "#{num_str}_#{slug}"
      self.save

      option.value = num
      option.save
    end
  end

  # def self.search(search)
  #   where("name LIKE ? OR tags LIKE ? OR notes LIKE ? OR url LIKE ? OR project_number LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  # end

  def self.project_scope
    where.not(project_state_id: PROJECT_SALES_STATE_ID)
  end

  def self.active_scope
    where(project_state_id: ACTIVE_ID)
  end

  def self.sales_case_scope
    where(project_state_id: PROJECT_SALES_STATE_ID)
  end

  def self.cold_sale_scope
    where(sale_case_status_id: COLD_ID)
  end

  def self.warm_sale_scope
    where(sale_case_status_id: WARM_ID)
  end

  def self.hot_sale_scope
    where(sale_case_status_id: HOT_ID)
  end

  def self.killed_sale_scope
    where(sale_case_status_id: KILLED_ID)
  end

  def project_estimated_total
    self.payment_schedules.sum(:total)
  end

  def project_total
    ps_id = PaymentStatus.find_by(name: 'Paid').id
    estimates = PaymentSchedule.where(project_id: self.id).where(payment_status_id: ps_id)
    estimates.sum(:total)
  end

  def get_num_string(num)
    if num<10
      num_str = "000#{num}"
    elsif num<100
      num_str = "00#{num}"
    elsif num<1000
      num_str = "0#{num}"
    else
      num_str = "#{num}"
    end
    return num_str
  end

end
