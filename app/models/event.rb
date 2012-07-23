class Event < ActiveRecord::Base
  
  attr_accessible :name, :start_at, :end_at, :votes
  after_initialize :init
  
  has_event_calendar 
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :start_at, presence: true
  
  def init
	self.votes ||= 0
  end
  
end
