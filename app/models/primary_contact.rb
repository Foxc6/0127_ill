class PrimaryContact < ActiveRecord::Base
  belongs_to :project
	belongs_to :contact
end
