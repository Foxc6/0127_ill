class Locale < ActiveRecord::Base
  has_many :admins
  has_many :users
  has_many :contacts
  has_many :activity_types
  has_many :task_types
  def self.increment code
    where(code:code).first.increment!(:submission_count)
  end

  def market_name
  	if self.code == 'na'
  		'USA'
  	else
  		'APAC'
  	end
  end
end
