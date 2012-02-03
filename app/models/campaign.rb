class Campaign
  include Mongoid::Document
  field :name, :type => String
  field :supporting, :type => String
  field :opposition, :type => String
  field :state, :type => String
end
