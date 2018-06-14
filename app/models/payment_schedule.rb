class PaymentSchedule < ActiveRecord::Base
	has_many :payment_line_items
	has_many :recievers
	has_many :contacts, through: :recievers
  belongs_to :project
  belongs_to :payment_term
  belongs_to :payment_status
  belongs_to :contact
  before_save :check_payment_status

  before_save :set_duration


  PAID_ID = PaymentStatus.find_by(name: 'Paid').id

  def check_payment_status
    if self.payment_status_id.blank?
      p_id = PaymentStatus.find_by(name: 'Pending').id
      self.payment_status_id = p_id
    end
  end

  def invoice_date=(date)
     begin
       parsed = Date.strptime(date,'%m/%d/%Y')
       super parsed
     rescue
       date
     end
  end

   def set_duration
    sD = self.invoice_date
    if sD.nil?
      sD = Time.now
    end
    if self.received_date.present?
      eD = self.received_date
    else
      eD = Time.now.end_of_year
    end
    diff = (eD.to_date - sD.to_date).to_i
    self.duration = diff
  end

  def self.payments_owed_sum
    sum = PaymentSchedule.where('payment_status_id != ?', PAID_ID).sum(:total)
    return sum
  end

  def self.paid_payments_sum
    sum = PaymentSchedule.where('payment_status_id = ?', PAID_ID).sum(:total)
    return sum
  end

  def received_date=(date)
     begin
       parsed = Date.strptime(date,'%m/%d/%Y')
       super parsed
     rescue
       date
     end
  end

  scope :by_year, lambda { |year| where('YEAR(received_date) = ?', year) }

end
