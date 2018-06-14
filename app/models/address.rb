class Address < ActiveRecord::Base
  belongs_to :contact
  belongs_to :state
  belongs_to :country
  belongs_to :estimate

  def address_dropdown_display
    "#{self.address1}, #{self.city}"
  end
end
