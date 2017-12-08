module Concerns
  module Provider
    module Foursquare
      extend ActiveSupport::Concern
      included do
        def foursquare
          @foursquare ||= Foursquare2::Client.new(:client_id => APP_CONFIG.foursquare.client_id,
                                                  :client_secret => APP_CONFIG.foursquare.client_secret)
          block_given? ? yield(@foursquare) : @foursquare
        # rescue Foursquare2::Client::APIError => e
        #   logger.info e.to_s
        #   nil 
        end

        def organize_photo(photo) 
          photo.prefix+"original"+photo.suffix
        end

        def organize_tip(tip) 
           ref = {:comment => tip.text, 
           :firstname =>  (organize_name(tip.user.firstName, false) + " " + organize_name(tip.user.lastName, true)),
           :user_image => organize_photo(tip.user.photo),
           :created_at =>  Time.at(tip.createdAt),
           :day_ago =>  I18n.t('conversations.messages.time_ago', time: distance_of_time_in_words(Time.at(tip.createdAt), Time.now.utc)),
           :category_name => "",
           :rating => "",
           :type => "foursquare"}
           return ref
        end

        def organize_name(name,last)
          if name.present?
            if name.length > 1 && last == true
              name[0].to_s + "."
            else
              name.to_s
            end
          else
            ""
          end
        end

        def set_workdones(business_type)
          types = business_type.split(",")

          types.each do |type|
            begin
              services = Array.new
              if type == "Bayan Kuaförü"  
                services = [{"Manikür"=>["Standart Manikür"]},
                            {"Pedikür"=>["Standart Pedikür"]},
                            {"Bayan Saç Kesimi"=>["Standart Kesim", "Düzeltme", "Kahkül", "Salon Dışı Uygulama"]},
                            {"Balyaj" =>  ["Komple Balyaj", "Kısmi Balyaj"]},
                            {"Dip Boya" =>  ["Standart Dip Boya", "Organik Dip Boya"] },
                            {"Gölge" =>   ["Kısa Saç İçin", "Uzun Saç İçin"]},
                            {"Komple Boya" => ["Standart Komple Boya",  "Organik Komple Boya"]},
                            {"Ombre" => ["Kısa Saç İçin", "Uzun Saç İçin"]},
                            {"Renk Değiştirme" => ["Uzun Saç İçin Boya İle",  "Uzun Saç İçin Dekolerya İle",  "Kısa Saç İçin Boya İle",  "Kısa Saç İçin Dekolerya İle"]},
                            {"Röfle" => ["Uzun Saç İçin Röfle",  "Kısa Saç İçin Röfle", "Kısmi Röfle"]},
                            {"Rütuş" => ["Kısa Saç İçin", "Uzun Saç İçin"]},
                            {"Fön" =>["Düz Fön", "Burgu Fön", "Dalgalı Fön"]},
                            {"Sir" => ["Yüz Bölgesi"]},
                            {"Gelin Saçı" =>  ["Salonda Uygulama", "Salon Dışı Uygulama", "Tesettür"]},
                            {"Gelin Paketi" => ["Salonda Uygulama", "Salon Dışı Uygulama", "Tesettür"]},
                            {"Maşa" =>  ["Komple Maşa", "Kısmi Maşa"]},
                            {"Profesyonel Makyaj"=>["Gece Makyajı","Gelin Makyajı","Gündüz Makyajı","Nişan Makyajı","Porselen Makyaj"]},
                            {"Perma" => ["Kısa Saç İçin",  "Uzun Saç İçin"]},
                            {"Topuz" => ["Modern Topuz",  "Normal Topuz"]},
                            {"Keratin Bakım (Brezilya Fönü)" =>["Gold", "Platinum"]},
                            {"Saç Bakım Terapisi"=> ["Hızlı Bakım", "Detaylı Bakım"]}]
              elsif type == "Erkek Kuaförü"
                 services = [{"Manikür"=>["Standart Manikür"]},
                            {"Pedikür"=>["Standart Pedikür"]},
                            {"Erkek Saç Kesimi"=>["Standart Kesim", "Özel Kesim", "Salon Dışı Uygulama"]},
                            {"Sir" => ["Yüz Bölgesi"]},
                            {"Klasik Cilt Bakımı" => ["Standart Uygulama"]},
                            {"Saç Bakım Terapisi" => [ "Hızlı Bakım", "Detaylı-Bakım"]},
                            {"Fön" => ["Erkekler İçin Fön"]},
                            {"Damat Saçı" => [ "Salonda Uygulama", "Salon Dışı Uygulama"]},
                            {"Damat Paketi" => [ "Salonda Uygulama", "Salon Dışı Uygulama"]}]
              elsif type == "Tırnak Merkezi"  
                services = [{"Ayak Mantarı"=> ["Standart Tedavi"]},
                            {"Batık Tırnak"=> ["Standart Tedavi"]},
                            {"Bunyon"=> ["Standart Tedavi"]},
                            {"Çatlak Topuk"=> ["Standart Tedavi"]},
                            {"Deforme Tırnak"=> ["Standart Tedavi"]},
                            {"Diyabetik Ayak"=> ["Standart Tedavi"]},
                            {"Manikür"=> ["Standart Manikür","Fransız Manikürü","Erkekler İçin Manikür"]}, 
                            {"Nasır"=> ["Standart Tedavi"]},
                            {"Oje"=> ["Ayak Ojesi","El Ojesi","Kalıcı Oje","Kalıcı Oje Çıkartma"]},
                            {"Parafin Bakımı"=> ["Standart Uygulama"]},
                            {"Pedikür"=> ["Standart Pedikür","Fransız Pedikürü","Erkekler İçin Pedikür"]}, 
                            {"Protez Tırnak"=> ["Akrilik Tırnak","Dipping Tırnak","Jel Tırnak","Protez Tırnak","Çıkartma"]},
                            {"Siğil"=> [" Standart Tedavi"]},
                            {"Tırnak Süsleme"=> ["Standart Uygulama"]},
                            {"Tırnak Mantarı"=> ["Standart Tedavi"]},
                            {"Tırnak Yeme"=> ["Standart Tedavi"]}] 
              elsif type == "Saç Kaynak Merkezi"  
                services = [{"Boncuk Saç Kaynak"=> ["Doğal Boncuk","Renkli Boncuk","Kaynak Sökme"]},
                            {"Keratin Saç Kaynak"=> ["Doğal Keratin","Renkli Keratin","İtalyan Doğal Keratin","İtalyan Renkli Keratin","Kaynak Sökme"]},
                            {"Mikro Saç Kaynak"=> ["Mikro Kapsül","Mikro Tube","Mikro Bant","Nano","Kaynak Sökme"]},
                            {"Mikrojel Saç Kaynak"=> ["Doğal Mikrojel","Renkli Mikrojel","Kaynak Sökme"]},
                            {"Organik Saç Kaynak"=> ["Doğal Organik","Renkli Organik","Örgü Düğümü","Brezilya Düğümü","Kaynak Sökme"]}]
              elsif type == "Masaj Salonu"  
                 services = [{"Anti Stres Masajı"=> ["Standart Uygulama"]},
                            {"Çikolata Masajı"=> ["Standart Uygulama"]},
                            {"Klasik Masaj"=> ["Standart Uygulama"]},
                            {"Köpük Masajı"=> ["Standart Uygulama"]},
                            {"Shiatsu Masajı"=> ["Standart Uygulama"]},
                            {"Sıcak Yağ Masajı"=> ["Standart Uygulama"]},
                            {"Spor Masajı"=> ["Standart Uygulama"]},
                            {"Taş Masajı"=> ["Standart Uygulama"]},
                            {"Tedavi Masajı"=> ["Standart Uygulama"]}]
              elsif type == "Güzellik Salonu" 
                  services = [{"Göz Çevresi Bakımı"=> ["Standart Uygulama"]},
                            {"Klasik Cilt Bakımı"=> ["Standart Uygulama"]},
                            {"Kök Hücre Bakımı"=> ["Standart Uygulama"]},
                            {"Myolifting"=> ["Standart Uygulama"]},
                            {"Nem Bakımı"=> ["Standart Uygulama"]},
                            {"Yaşlanma Karşıtı"=> ["Standart Uygulama"]},
                            {"Kaş Alma"=> ["Standart Uygulama"]},
                            {"Kaş Boyama"=> ["Standart Uygulama"]},
                            {"Kaş Dolgu"=> ["Standart Uygulama"]},
                            {"Kaş Şekillendirme"=> ["Standart Uygulama"]},
                            {"İpek Kirpik"=> ["Tekli Uygulama", "3D Uygulama", "Mink Uygulama", "Bakım İşlemi"]},
                            {"Kirpik Boyama"=> ["Standart Uygulama"]},
                            {"Kirpik Perması"=> ["Standart Uygulama"]},
                            {"Kalıcı Makyaj"=> ["Dudak Makyajı", "Göz Makyajı", "Kaş Makyajı"]},
                            {"Profesyonel Makyaj"=> ["Artistik Makyaj", "Gece Makyajı", "Gelin Makyajı", "Gündüz Makyajı", "Nişan Makyajı", "Plastik Makyaj", "Porselen Makyaj", "Sahne Makyajı"]}, 
                            {"Sir"=> ["Komple", "Yarım", "Kol Altı", "Bütün Kol", "Yarım Kol", "Bütün Bacak", "Yarım Bacak", "Bikini Bölgesi", "Yüz Bölgesi", "Kaş ve Bıyık Sırt", "Göbek", "Göğüs"]},       
                            {"IPL Epilasyon"=> ["1 Seans Tüm vücut", "1 Seans Çene", "1 Seans Koltuk Altı", "1 Seans Favoriler", "1 Seans Genital Bölge", "1 Seans Boyun", "1 Seans Tüm Bacak", "1 Seans Sakal Üstleri", "1 Seans Üst Bacak", "1 Seans Kulaklar 1 Seans Alt Bacak", "1 Seans Ense", "1 Seans Bikini Bölgesi", "1 Seans Omuzlar", "1 Seans Kalçalar", "1 Seans Bel", "1 Seans Tüm Kol", "1 Seans Omuzlar + Bel", "1 Seans Yarım Kol", "1 Seans Göğüs", "1 Seans Tüm Yüz", "1 Seans Göbek", "1 Seans Kaş Üstleri", "1 Seans Göğüs + Göbek", "1 Seans Kaş Ortası", "1 Seans El Üstleri", "1 Seans Dudak Üstü", "1 Seans Ayak Üstleri"]},
                            {"Manikür"=> ["Standart Manikür", "Fransız Manikürü", "Erkekler İçin Manikür"]}, 
                            {"Oje"=> ["Ayak Ojesi", "El Ojesi", "Kalıcı Oje", "Kalıcı Oje Çıkartma"]},
                            {"Parafin Bakımı"=> ["Standart Uygulama"]},
                            {"Pedikür"=> ["Standart Pedikür", "Fransız Pedikürü", "Erkekler İçin Pedikür"]}] 
              else
              end  
              services.each do |service|
                key = service.keys.first
                value = service["#{key}"]
                category = Category.find_by(:title=>key) 
                variationsx = category.business_function.variations
                variations = variationsx.map{|v| v if value.include?(v.variation)}.compact
                workdone =  self.workdones.find_by(:category_id =>category._id) 
                if workdone.blank?
                  workdone = self.workdones.build 
                  workdone.category_id = category._id
                  workdone.give_price = false
                  workdone.save! 
                end
                variations.each do |variation|
                  price = workdone.prices.build
                  price.variation_id = variation._id
                  price.staff_ids = [self.user._id]
                  price.price = nil
                  price.duration = variation.duration
                  price.discount = 0
                  price.save!
                end 
              end
              self.save!
            rescue Exception => e
              Rails.logger "exception!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" 
            end
          end
        end

        def update_foursquare_data(result)
          self.foursquare_data[:name] = result[:name]
          self.foursquare_data[:contact] = result[:contact]
          self.foursquare_data[:address] = result[:location][:formattedAddress]
          self.foursquare_data[:checkinscount] = result[:stats][:checkinsCount]
          self.foursquare_data[:userscount] = result[:stats][:usersCount]
          self.foursquare_data[:likescount] = result[:likes][:count]
          self.foursquare_data[:url] = result[:url]
          self.foursquare_data[:rating] = result[:rating]
          self.foursquare_data[:ratingSignals] = result[:ratingSignals] 
          self.foursquare_data[:photos] = result[:photos][:groups].present? ? result[:photos][:groups].map{|g| g.items}.reduce(:+).map{|i| organize_photo(i)} : nil
          self.foursquare_data[:tips] = result[:tips][:groups].present? ? result[:tips][:groups].map{|g| g.items}.reduce(:+).map{|i| organize_tip(i)} : nil
          self.foursquare_data[:timeframes] = result[:popular].present? ? result[:popular][:timeframes] : nil
          self.foursquare_data[:attributes] = result[:attributes]
          self.save! 
        end

        def cache_foursquare_data?
          begin
            foursquare do |fs|
              result = fs.venue(self.foursquare_data[:uri].split("/").last, :v=>Date.today.strftime("%Y%m%d"))
              if result.any?
                self.foursquare_data[:name] = result[:name]
                self.foursquare_data[:address] = result[:location][:formattedAddress]
                self.foursquare_data[:stats] = result[:stats]
                self.foursquare_data[:likes] = result[:likes]
                self.foursquare_data[:url] = result[:url]
                self.foursquare_data[:rating] = result[:rating]
                self.foursquare_data[:ratingSignals] = result[:ratingSignals] 
                self.foursquare_data[:photos] = result[:photos][:groups].map{|g| g.items}.reduce(:+).map{|i| organize_photo(i)}
                self.foursquare_data[:tips] = result[:tips][:groups].map{|g| g.items}.reduce(:+).map{|i| organize_tip(i)}
                self.foursquare_data[:timeframes] = result[:popular][:timeframes]
                self.foursquare_data[:attributes] = result[:attributes]
                 self.save!
                return true
              else
                false 
              end
            end
          rescue => e
            logger.warn "Unable to foo, will ignore: #{e}" 
          end
        end

        module ClassMethods
        end

      end
    end
  end
end
