class PaymentLineItem < ActiveRecord::Base
  belongs_to :payment_schedule
end
