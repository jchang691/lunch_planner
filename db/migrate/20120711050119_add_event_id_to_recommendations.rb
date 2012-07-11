class AddEventIdToRecommendations < ActiveRecord::Migration
  def change
	add_column :recommendations, :event_id, :integer
	add_column :recommendations, :votes, :integer
  end
end
