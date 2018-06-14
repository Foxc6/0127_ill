class ReferralContact < ActiveRecord::Base
	belongs_to :contact
	belongs_to :project

  def full_name
    conatact = Contact.where(id: self.contact_id).first
    if contact
      "#{contact.first_name} #{contact.last_name}"
    else

    end
  end
end
