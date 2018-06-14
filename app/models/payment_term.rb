class PaymentTerm < ActiveRecord::Base
  has_many :payment_schedules
end
