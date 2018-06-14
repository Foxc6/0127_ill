class ProjectContact < ActiveRecord::Base
  belongs_to :contact
  belongs_to :project
end
