class ActivityObject < ActiveRecord::Base
  belongs_to :locale

  def self.user_scope
    where(locale_id: Rails.application.config.user_locale_id)
  end
end
