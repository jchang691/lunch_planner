class RecommendationsController < ApplicationController

	def create
		@user = User.find(params[:user_id])
		new_rec = Recommendation.new(params[:recommendation])
    	eventId = new_rec.event_id
		if can_create_rec(@user.id, new_rec.event_id)
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
      event = Event.find(eventId)
			flash[:success] = "You have already made a Recommendation for #{event.name}"
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
    Recommendation.find(params[:id]).votes.each do |rec|
      rec.destroy
    end
		Recommendation.find(params[:id]).destroy
		flash[:success] = "Recommendation deleted."
		redirect_to event
	end
	
  private
  
	def can_create_rec(id, event_id)
		count = 0
		rec = Recommendation.find(:all, :conditions => {:event_id=>event_id})
		rec.each do |x|
			if id == x.user_id
				count+= 1
			end
			return false if count >= 1
		end
		true
	end

end
