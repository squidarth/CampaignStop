class PagesController < ApplicationController
  def home
    if !user_signed_in?
      render :splash, :layout => false


    else

    end
  end


  def splash


  end

  def about
  end

  def contact
  end

end
