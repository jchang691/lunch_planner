class AddNumVotesToVotes < ActiveRecord::Migration
  def change
	add_column :votes, :num_votes, :integer
  end
end
