Fabricator(:provider) do 
  user 
  business_address {"Bostanlı Mh., 6352. Sokak No:15, 35480 İzmir, Türkiye"}
  business_description {"Biz de sadece epilasyon işleriyle uğraşıyoruz ve bu işlerin hizmetini veriyoruz" }
  business_email {Faker::Internet.email } 
  office_phone {Faker::Number.number(11)}
  business_phone {Faker::Number.number(11)}
  website {"www.caner.com"}
  business_type {0}
  location {[38.4362841,27.1446302]}
  latitude {27.1446302}
  longitude {38.4362841}
  mobile_verified {true}
  officialname {Faker::Company.name }
  overall_quote_done {0}
  overall_quote_given {6}
  overall_score {30}
  provider_images {{ :provider_image1=> ["http://hizmetkutusu.s3.amazonaws.com/41/f2d480d1f611e388eed9d404f5dc38/hazir_mutfak4.jpg", 	"http://hizmetkutusu.s3.amazonaws.com/42/cc1d80d1f611e39ff8770eaa4c44bf/hazir_mutfak4.jpg", 	"http://hizmetkutusu.s3.amazonaws.com/41/e89b50d1f611e39130058056b4627f/hazir_mutfak4.jpg" ]}}
  tax_business_name {"dsadsd32 312321sa"}
  tax_fullname {"dsa ds dsad sads"}
  tax_number {Faker::Number.number(10)}
  tax_office {"dsadsdsa"}
  tax_pin {Faker::Number.number(11)}
  verified {true} 
  foursquare_data {{:uri=>"https://foursquare.com/v/key-kuaf%C3%B6r-ve-g%C3%BCzellik-salonu/4fcd142fe4b0131cb4ac0121"}}
  facebook_data {{:uri=>"https://www.facebook.com/pages/KEY-KUAF%C3%96R/200929789306"}}
  twitter_data {{:address=>"https://twitter.com/KeyCoiffeur"}}               
  googleplus_data {{:uri=>"https://plus.google.com/114075694242254283754/posts"}}
  instagram_data {{:uri=>"http://instagram.com/keykuafor"}}
  business_hours { [{"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"18:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"18:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"18:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"18:00"}, {"isActive"=>true, "timeFrom"=>"09:00", "timeTill"=>"18:00"}, {"isActive"=>false, "timeFrom"=>"09:00", "timeTill"=>"18:00"}, {"isActive"=>false, "timeFrom"=>"09:00", "timeTill"=>"18:00"}]}
  decomposed_address {{:postcode=> "10101", :local=> "Yağcami", :neigbor=> "Karasoku Mah.",  :province => "Adana", :district=>"Seyhan",:street => "1232", :no_door => "12" }}
  gmaps {true}
  verified {true}  
end
 