class Campaign
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :name, :type => String
  field :supporting, :type => String
  field :opposition, :type => String
  field :state, :type => String

  field :administrator_id, :type => String
  embeds_many :houses




  has_and_belongs_to_many :users

  has_mongoid_attached_file :image,
    :storage => :s3,
    :bucket => 'campaignstop',
    :styles => {:thumb => "75x75>", :small => "150x150>", :normal => "250x250>", :large => "450x450>" }, 
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":attachment/:id/:style.:extension" 

  attr_accessible :name, :supporting, :opposition, :state, :administrator_id, :image


  #dispatch accepts a number of users and a number of hours and dispatches a number of houses
  #uses k-clustering
  
  def dispatch(num_users, num_hours)
    require 'open-uri'
    require 'json'
    
    puts "dispatch Called"
    a = 0.00001/2
    area_to_cover = area_to_cover(num_users, num_hours, a)

    
    @houses = self.houses
      
    house_mappings  = {}
    points = []
    @houses.each do |house|
       request = "http://maps.googleapis.com/maps/api/geocode/json?address=#{house.address},#{house.city},#{house.state}&sensor=false"
       request.gsub!(" ", "+")
       contents = open(request).read       
       google = JSON.parse(contents) 
       lat = google["results"][0]["geometry"]["location"]["lat"]
       long = google["results"][0]["geometry"]["location"]["lng"]
       point = [lat, long, house]
       points << point 
    end
  
    puts "Lat/long calculated" 
    clusters = get_clusters(points, area_to_cover)
 
    #output: points that the group should use (addresses)
    puts "Clusterslength: #{clusters.length}"
    first_cluster = nil
    clusters.each do |cluster|
      if cluster.length != 0
        first_cluster = cluster
      end

      
    end

    unformatted_solutions = []
    first_cluster.each do |point|
      unformatted_solutions << points[point]
    end

    solutions = unformatted_solutions.collect {|solution| solution[2] }

    return solutions
  end

  private 



  def area_to_cover(num_users, num_hours, a)
    return a*num_users*num_hours 

  end

  def get_clusters(points, area_covered)
    require 'rubygems'
    require 'k_means'
    
    puts "get clusters called"
    num_clusters = get_area(points)/area_covered

    data = points.collect {|point| [point[0],point[1]] }
    kmeans = KMeans.new(data, :centroids => num_clusters.to_i)
    
    puts "get clusters complete"
    return kmeans.view
    

  end


  def get_area(points)
     top_most_point = -100000000000000000
     left_most_point = 1000000000000000
     right_most_point = -1000000000000000
     bottom_most_point = 100000000000000


     pi = 3.1415926
     points.each do |point|
        if(point[0] > right_most_point)
          right_most_point = point[0]
        end

        if point[0] < left_most_point
          left_most_point = point[0]
        end

        if point[1] < bottom_most_point
          bottom_most_point = point[1]
        end

        if point[1] > top_most_point
          top_most_point = point[1]
        end
     end


     vertical = top_most_point - bottom_most_point
     horizontal = right_most_point - left_most_point

     average_diameter = (vertical+horizontal)/2
     
     radius = average_diameter/2

     return pi*(radius**2)
  end


end
