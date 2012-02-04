class House
  include Mongoid::Document
  
  #Address details
  field :address, :type => String
  field :city, :type => String
  field :zip, :type => String
  field :state, :type => String

  field :lat, :type => Float
  field :long, :type => Float
  field :affiliation, :type => String
  field :visits, :type => Integer, :default => 0

  field :dispatched, :type => Boolean

  embedded_in :campaign

end
