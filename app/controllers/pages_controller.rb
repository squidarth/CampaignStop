class PagesController < ApplicationController
  def home
    if !user_signed_in?
      render :splash, :layout => false


    else
      @campaigns = Campaign.all
    end
  end



  def splash


  end

  def about
  end

  def contact
  end

end
