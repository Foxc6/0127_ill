class Reciever < ActiveRecord::Base
	belongs_to :contact
	belongs_to :payment_schedule
end
