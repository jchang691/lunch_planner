class AddVotesToEvents < ActiveRecord::Migration
  def change
	add_column :events, :votes, :integer
  end
end
