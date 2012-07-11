class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
	  t.references :user

      t.timestamps
    end
	add_index :recommendations, :user_id
  end
end
