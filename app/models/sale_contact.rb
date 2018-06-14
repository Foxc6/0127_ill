class SaleContact < ActiveRecord::Base
	belongs_to :contact
	belongs_to :project

  def full_name
    if contact
      "#{contact.first_name} #{contact.last_name}"
    else

    end
  end
end
