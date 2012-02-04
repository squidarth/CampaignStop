class HousesController < ApplicationController
  def create
    @campaign = Campaign.find(params[:house][:campaign_id])
    @campaign.houses.create!(params[:house])
    redirect_to campaign_manage_path(@campaign) 
  end

  def destroy
  end

end
