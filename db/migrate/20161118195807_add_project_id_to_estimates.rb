class AddProjectIdToEstimates < ActiveRecord::Migration
  def change
    add_reference :estimates, :project, index: true
  end
end
