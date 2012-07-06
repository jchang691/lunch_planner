class EventsController < ApplicationController
	
	 before_filter :signed_in_user, only: [:index, :create, :edit, :update, :destroy, :show, :new]
	
	def show
		@event = Event.find(params[:id])
		@time = @event.start_at
		@time_end = @event.end_at
	end
	  
	def new
		@event = Event.new
    end
	
	def index
		@events = Event.paginate(page: params[:page])
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
	
	
end
