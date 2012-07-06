class StaticPagesController < ApplicationController
  def home
	if signed_in?
		redirect_to calendar_path
	end
  end

  def help
  end
  
  def contact
  end
  
end
