class EventsController < ApplicationController
	
	 before_filter :signed_in_user, only: [:index, :create, :edit, :update, :destroy, :show, :new]
	 before_filter :admin_user, only: [:index, :create, :edit, :update, :destroy, :new]
	
	def show
		@event = Event.find(params[:id])
		@today = @event.start_at.to_date
		@tomorrow = @event.start_at.tomorrow.to_date
		@recommendations = Recommendation.find(:all, :conditions => ["start_at between ? and ?", @today, @tomorrow])
		@time = @event.start_at
		@time_end = @event.end_at
	end
	  
	def new
		@event = Event.new
    end
	
	def index
		@events = Event.paginate(page: params[:page])
	end
	
	def vote_up
		@recommendation = Recommendation.find(params[:id])
		prev_votes = @recommendation.votes
		@recommendation.update_attribute(:votes, prev_votes+1)
		redirect_to :back
	end
	
	def create
		@event = Event.new(params[:event])
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
end
