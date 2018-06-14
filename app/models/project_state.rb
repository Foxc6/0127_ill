class ProjectState < ActiveRecord::Base
	has_many :projects

  # searchable do
  #   text  :name
  # end
end
