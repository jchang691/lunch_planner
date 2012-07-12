class Vote < ActiveRecord::Base
  attr_accessible :event_id, :name, :recommendation_id
  
  belongs_to :user
  belongs_to :recommendation
  
end
