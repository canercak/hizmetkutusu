Fabricator(:address) do 
  title {"Ardahan"}
  ancestors {nil} 
  parent { nil}
  postcode { nil}

  after_create do 
  	if Address.find_by(:title=>"Balıkesir").blank?
	  	Fabricate(:address, title: "Balıkesir")
	  end
  	if Address.find_by(:title=>"Adana").blank?
	  	Fabricate(:address, title: "Adana")
	  end
  	if Address.find_by(:title=>"Seyhan").blank?
	  	Fabricate(:address, title: "Seyhan", ancestors: ["Adana" ], parent:  "Adana")
	  end
	  if Address.find_by(:title=>"Yağcami").blank?
	  	Fabricate(:address, title: "Yağcami", ancestors: [ "Adana",  "Seyhan"], parent: "Seyhan",  postcode: 10101)
	  end
	  if Address.find_by(:title=>"Karasoku Mah.").blank?
	  	Fabricate(:address, title: "Karasoku Mah.", ancestors: [ "Adana",  "Seyhan",  "Yağcami"], parent: "Yağcami")
		end
	end
end
 