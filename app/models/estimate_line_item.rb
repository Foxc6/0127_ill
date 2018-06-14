class EstimateLineItem < ActiveRecord::Base
  belongs_to :estimate

  belongs_to :parent, :class_name => 'EstimateLineItem'
  has_many :children, :class_name => 'EstimateLineItem', :foreign_key => 'parent_id'

end
