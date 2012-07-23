class EventsController < ApplicationController
	
	 before_filter :signed_in_user, only: [:index, :create, :edit, :update, :destroy, :show, :new]
	 before_filter :admin_user, only: [:index, :create, :edit, :update, :destroy, :new]
	
	def show
		@event = Event.find(params[:id])
		@today = @event.start_at.to_date
		@tomorrow = @event.start_at.tomorrow.to_date
		@recommendations = Recommendation.find(:all, :conditions => {:event_id=> @event.id})
		sort_by_votes(@recommendations)
     
	end
	  
	def new
		@event = Event.new
    end
	
	def index
		@events = Event.paginate(page: params[:page])
	end
	
	def vote_up
		@event = Event.find(params[:id])
		@recommendation = Recommendation.find(params[:rec_id])
		@votes = Vote.find(:all, :conditions=>{:event_id=>@event.id, :user_id=>current_user.id})
		if @votes.empty?
			@vote = current_user.votes.create({:event_id=>@event.id, :recommendation_id=>@recommendation.id})
			@vote.save
      flash[:success] = "Voted for #{@recommendation.name}"
    else
      #There should only be one element in @votes
      if @votes[0].recommendation_id != @recommendation.id
          prev_rec = Recommendation.find(@votes[0].recommendation_id) 
          flash[:success] = "Vote changed from #{prev_rec.name} to #{@recommendation.name}"
          @votes[0].update_attribute(:recommendation_id, @recommendation.id)
      else
        flash[:error] = "Cannot Vote for #{@recommendation.name} twice"
      end
		end
		
		#prev_votes = @recommendation.votes
		#@recommendation.update_attribute(:votes, prev_votes+1)
		redirect_to :back
	end
	
	def create
		@event = Event.new(params[:event])
		@event.end_at = @event.start_at
		if @event.save
		  flash[:success] = "Event Created!"
		  redirect_to @event
		else
		  render 'new'
		end
	end
	
	def destroy
		id = Event.find(params[:id]).id
		rec = Recommendation.find(:all, :conditions=> {:event_id=> id})
		rec.each do |x|
			x.destroy
		end
		Event.find(params[:id]).destroy
		flash[:success] = "Event destroyed."
		redirect_to(:back)
	end
	
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end
	
	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def sort_by_votes(rec_array)
    	rec_array.each_with_index do |rec, i|
    		j = i-1
    		while j >= 0
    			break if rec_array[j].votes.length <= rec.votes.length
    			rec_array[j+1] = rec_array[j]
    			j = j-1
    		end
    		rec_array[j+1] = rec
    	end
    end
end
