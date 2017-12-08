class Address
  include Mongoid::Document
  field :title
  field :postcode, :type=>Integer, :default=>nil
  field :ancestors, :type=> Array, :default=>nil
  field :parent, :default=> nil
 

  def self.get_children(parent, grandparent, postcode)
    addresses,result = nil, Array.new
    if postcode == nil
	    addresses = Address.where(:parent=> parent, :ancestors=>grandparent, :postcode=>nil).order_by(:title.asc).to_a
 	  else
			addresses = Address.where(:parent=> parent, :ancestors=>grandparent,  :postcode.ne=>nil).order_by(:title.asc).to_a
 	  end 
    data = Jbuilder.encode do |json|
      json.array! addresses do |address|
        json.text address.title 
      end
    end  
    JSON.parse(data).each do |d|
      array = [] 
      2.times do
        array << d["text"]
      end
      result << array
    end 
    return result
  end

  def self.generate_address(location)
    geocoded_address = Geocoder.search("#{location[0]},#{location[1]}") 
    address = Hash.new
    if geocoded_address.present?
      address[:formatted_address] = geocoded_address[0].data["formatted_address"]
      geocoded_address[0].data["address_components"].each do |var|
        if var["types"][0] == "route"
          address[:street] = var["long_name"]
        elsif var["types"][0] == "neighborhood"
          address[:local] = var["long_name"]
        elsif var["types"][0] == "locality" 
          address[:province] = var["long_name"]
        elsif var["types"][0] == ("sublocality_level_1") 
          address[:district] = var["long_name"]    
        elsif var["types"][0] == ("administrative_area_level_2") 
          address[:district] = var["long_name"]   
        elsif var["types"][0] == "postal_code" 
          address[:postcode] = var["long_name"] 
        elsif var["types"][0] == "street_number" 
          address[:no_door] = var["long_name"]
        else
        end 
      end 
      local_keyword = address[:local].split(" ")[0]
      neigbor = Address.any_of({ :title => /.*#{local_keyword}.*/ }).where(:ancestors=>address[:district] ).to_a
      if neigbor.present? && neigbor.count == 1
        address[:neigbor] = neigbor[0].ancestors.last
      else
        address[:neigbor] = "notfound " + local_keyword
      end
    end
    return address
  end


  def self.decompose_address(location, params)
    address = Hash.new
    add = Address.find_by(:title=>params["neigbor"]) 
    address[:province] = params["province"]
    address[:district] = params["district"]
    address[:neigbor] = params["neigbor"]
    address[:local] = params["local"]
    address[:street] = params["street"]
    address[:no_door] = params["no_door"]
    address[:address_id] = params["street"]
    postcode =  Address.where(:parent=> params["district"], :ancestors=>params["province"], :title=>params["neigbor"]).to_a[0].postcode
    address[:postcode] = postcode.present? ? postcode.to_s : nil
    return address
  end



 
end
 