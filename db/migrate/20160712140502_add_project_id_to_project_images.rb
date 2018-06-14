class AddProjectIdToProjectImages < ActiveRecord::Migration
  def change
    add_reference :project_images, :project, index: true
  end
end
