class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  
  def show
    @user = User.find(params[:id])
    @campaigns = @user.campaigns

    if @user.campaign_administrator
      @campaigns_i_administrate = Campaign.where(:administrator_id =>  @user.id)

    end
  end


  def join_campaign
    @campaign = Campaign.find(params[:id])
    @campaign.users << current_user

    @campaign.save

    current_user.campaigns << @campaign
    redirect_to @campaign

  end

end
