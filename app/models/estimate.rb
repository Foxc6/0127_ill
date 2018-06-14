class Estimate < ActiveRecord::Base
  has_many :estimate_line_items, :dependent => :destroy
  has_many :addresses
  before_save :set_company_id
  before_create :set_number
  before_save :set_total
  before_save :set_date

  accepts_nested_attributes_for :estimate_line_items, :reject_if=> proc {|attributes| attributes[:description].blank?}, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true

  belongs_to :project

  belongs_to :client, :class_name => :Contact,:foreign_key => "client_id", touch: true

  validates :client_id, :presence => true


  def set_company_id
  	@company_id = Option.find_by(key: 'estimate_company_id').value
  	if self.company_id == nil
      self.company_id = @company_id
    end
  end

  def set_number
  	@estimates = Estimate.all
    if @estimates.any?
      pre = Estimate.order(:number).last
      pre_number = pre.number
      pre_int = pre_number.to_i
      new_int = sprintf '%04d', (pre_int+1)
      string = new_int.to_s
      self.number = string
    else
      self.number = (sprintf '%04d', 1).to_s
    end
  end

  def set_total
    line_items = EstimateLineItem.where(estimate_id: self.id).where("price IS NOT NULL")
    self.total = line_items.to_a.sum { |estimate_line_item| estimate_line_item.price }
  end

  def set_date
    @date = Time.now
    self.date = @date
  end
end
