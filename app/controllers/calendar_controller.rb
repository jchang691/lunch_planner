require 'date'
class CalendarController < ApplicationController
  
  before_filter :signed_in_user, only: [:index, :day, :edit, :update, :destroy]
  
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)
  end
  
  def day
	@year = (params[:year] || (Time.zone || Time).now.year).to_i
	@month = (params[:month] || (Time.zone || Time).now.month).to_i
	@month_name = Date::MONTHNAMES[@month]
	@day = (params[:day] || (Time.zone || Time).now.day).to_i
	date = Date.new(@year, @month, @day)
	date_next = Date.new(@year, @month, @day+1)
	@events = Event.find(:all, :conditions =>["start_at between ? and ?", date, date_next])
	
  end
  
  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end
  
end
