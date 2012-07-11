class RecommendationsController < ApplicationController

	def create
		@user = User.find(params[:user_id])
		new_rec = Recommendation.new(params[:recommendation])
		if can_create_rec(@user.id, new_rec.start_at)
			@recommendation = @user.recommendations.create(params[:recommendation])
			if @recommendation.save
			  flash[:success] = "Recommendation Created"
			  eventId = @recommendation.event_id
			  event = Event.find(eventId)
			  redirect_to event
			else
			  render 'new'
			end
		else
			flash[:success] = "You have already made 2 Recs for the day"
			redirect_to :back
		end
	end
	
	def new
		@user = User.find(params[:user_id])
		@recommendation = Recommendation.new
	end
	
	def show
		@user = User.find(params[:user_id])
		@recommendation = Recommendation.find(params[:id])
		
	end
	
	def index
	
	end
	
	def vote_up
		@recommendation = Recommendation.find(params[:id])
		prev_votes = @recommendation.votes
		@recommendation.update_attribute(:votes, prev_votes+1)
	end
	
	def destroy
		eventId = Recommendation.find(params[:id]).event_id
		event = Event.find(eventId)
		Recommendation.find(params[:id]).destroy
		flash[:success] = "Recommendation destroyed."
		redirect_to event
	end
	
  private
  
	def can_create_rec(id, start)
		count = 0
		today = start.to_date
		tomorrow = start.tomorrow.to_date
		rec = Recommendation.find(:all, :conditions => ["start_at between ? and ?", today, tomorrow])
		rec.each do |x|
			if id == x.user_id
				count+= 1
			end
			return false if count >= 2
		end
		true
	end

end