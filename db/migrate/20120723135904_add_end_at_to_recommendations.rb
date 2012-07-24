class AddEndAtToRecommendations < ActiveRecord::Migration
  def change
	add_column :recommendations, :end_at, :datetime
  end
end
