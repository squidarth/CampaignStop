class CampaignsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    

  end
  
  def show
    @campaign = Campaign.find(params[:id])
    
  
  
  end

  def manage
    if user_signed_in? && current_user.campaign_administrator
      @campaign = Campaign.find(params[:id])

    else 
      redirect_to root_path
    end



  end


  def manage_houses
    if user_signed_in? && current_user.campaign_administrator
      @campaign = Campaign.find(params[:id])
      @houses = @campaign.houses


    else
      redirect_to root_path
    end

  end

  def dispatch_houses
    @campaign = Campaign.find(params[:id])
    num_users = 0

    params["user"].each do |user|
      if user.length !=0
         num_users = num_users = 1
      end
    end

    @houses = @campaign.dispatch(num_users, params[:time].to_i)

    @houses.each do |house|
      house.dispatched = true
      house.save!
  
    end

 end


  def new
    if current_user.campaign_administrator

    else
      redirect_to root_path
    end
  
  
  end

  def create
    if current_user.campaign_administrator
       @campaign = Campaign.create!(params[:campaign])
       redirect_to @campaign
    else
      redirect_to root_path
    end

  
  
  end

  def destroy
  end

  def edit
  end

  def update
  end

end
