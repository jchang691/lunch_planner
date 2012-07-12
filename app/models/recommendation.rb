class Recommendation < ActiveRecord::Base
  attr_accessible :description, :name, :start_at, :event_id, :votes
  
  belongs_to :user
  has_many :votes
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :start_at, presence: true
  validates :description, presence: true
  
  
	def vote_up
		self.votes += 1
		self.save
	end
end
