class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :name
      t.integer :event_id
      t.integer :recommendation_id
	  t.references :user

      t.timestamps
    end
	add_index :votes, :user_id
  end
end
