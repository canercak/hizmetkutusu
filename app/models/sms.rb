require 'net/http'
require 'uri'
require "open-uri"  
class Sms
  include Mongoid::Document
  include Mongoid::Timestamps
  include UsersHelper
  include ReferencesHelper
  include ProvidersHelper
 
  field :incoming, :type=> Boolean
  field :type
  field :phone
  field :time
  field :answered
  field :return_word
  field :quote_id
  
  def build_xml(phone_array, message_array)
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.mainbody {
      xml.header {
          xml.company "NETGSM"
          xml.usercode "5322814785"
          xml.password "3X7G3H8"
          xml.type "n:n"
          xml.msgheader APP_CONFIG.sms_from 
        }
      xml.body {
        phone_array.each_with_index do |phone, index|
          xml.mp {
            xml.msg message_array[index]
            xml.no phone_array[index]
          }
        end 
      }  
    }
    end
    return builder.to_xml
  end
 
   def send_single_sms(phone, message, return_word, type, quote_id) 
    username = "5322814785"
    password = "3X7G3H8" 
    from = "8503026096"
    res = nil
      send_url = 'http://api.netgsm.com.tr/bulkhttppost.asp?usercode='+username+'&password='+password+'&gsmno='+phone+'&message='+message+'&msgheader='+from+'&startdate=&stopdate='
      url = URI.parse(URI.encode(send_url))            
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|  http.request(req)   }
 
    if res.to_s.include? "OK"
        outgoing = Sms.new
        outgoing.incoming = false
        outgoing.return_word = return_word 
        outgoing.quote_id = quote_id
        outgoing.type = type
        outgoing.phone = phone
        outgoing.answered = false
        outgoing.save!
      return true
    else
      return false
    end
  end
 
 
  
  def send_multi_sms(phone_array, message_array,  type, quote_id) 
    unless (Rails.env.test? || Rails.env.development?) 
      xml = build_xml(phone_array,  message_array)
      uri = URI.parse("http://api.netgsm.com.tr/xmlbulkhttppost.asp")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = xml
      response = http.request(request)
      if response.to_s.include? "OK"
        phone_array.each_with_index do |phone,index|
          outgoing = Sms.new
          outgoing.incoming = false
          outgoing.quote_id = quote_id
          outgoing.type = type
          outgoing.phone = phone
          outgoing.answered = false
          outgoing.save
        end
        return true
      else
        return false
      end
    end
  end
   
  def check_incoming_sms 
    my_hash = { :header =>{:company => 'NETGSM', :usercode => '5322814785', :password => '3X7G3H8',
                :startdate=> (Time.now - 2.minutes).strftime("%d%m%Y%H%M"), :stopdate => Time.now.strftime("%d%m%Y%H%M")}} #cannot be more than 30
    uri = URI.parse("http://api.netgsm.com.tr/xmlgelenmesaj.asp")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = my_hash.to_xml(:root => 'mainbody')
    response = http.request(request)
    split_body= response.body        
    if response.body == "40"
      return
    end
    arr=[]
    arr =  split_body.split("<br>")
    regex = /\d{2}\.\d{2}\.\d{4} \d{2}:\d{2}:\d{2}/ 
    arr.each do |htmlstring|  
      time_of_sms = Time.parse(htmlstring[regex]) 
      answer = htmlstring.split("|")[1].strip
      check_sms = Sms.where(:answered => false, :time.ne => time_of_sms)
      if check_sms.present? 
        incoming = Sms.new
        incoming.phone = "0"+htmlstring[0,10]
        incoming.time =  Time.parse(htmlstring[regex]) 
        incoming.answered = false
        incoming.return_word = answer
        incoming.incoming = true
        if  answer.upcase == "EVET"
          incoming.type = "quotegive"
        elsif  answer.upcase == "TAMAM"
          incoming.type = "quotedo"
        elsif reference_array.include? answer.upcase 
          incoming.type = "userreference"                           
        else
          incoming.type = "wrong"
        end       
        incoming.save 
        answer_to_incoming(incoming)
      else
        ##no sms to check
      end 
    end
  end
  
  def answer_to_incoming(incoming)
     if incoming.type == "quotegive"  
        provider_outgoing = Sms.where(:phone=> incoming.phone, 
                                      :incoming=>false, :type=>"newquote", :answered=>false,
                                      :created_at.gt => (Time.now - 24.hours)) 
        if provider_outgoing.present?
          provider_outgoing.each do |outgoing|     
            if (outgoing.return_word == incoming.return_word.upcase) && incoming.answered ==false
              quote = Quote.find(outgoing.quote_id)
              provider = Provider.find_by(:business_phone=>incoming.phone,:quote_ids=>quote.id)
              if quote.present? && provider.present?
                # if Quote.give_quote(quote, provider)                  
                #   if quote.call_with_phone == true
                #     message = "Musteri adi: #{get_first_name(quote.user.name)}, Telefonu: #{quote.user.telephone}. Sadece kendisiyle anlasip isi bitirmeniz durumunda bu mesaja TAMAM yazarak cevap veriniz.#{rand(23)} "
                #   else
                #     no_phone_link = Googl.shorten("#{APP_CONFIG.base_url}/users/#{quote.user.username}").short_url
                #     message = "Musteri adi: #{get_first_name(quote.user.name)}, kendisi telefonla aranmak istemiyor. Şu linki kullanarak teklif veriniz #{no_phone_link}. Lütfen Sadece kendisiyle anlasip isi bitirmeniz durumunda bu mesaja TAMAM yazarak cevap veriniz.#{rand(23)} "
                #   end
                #   if send_multi_sms([provider.business_phone] ,[message],["TAMAM"], "quotegiven", quote.id)
                #     incoming.answered = true
                #     outgoing.answered = true
                #     outgoing.save!
                #     incoming.save!
                #     ProviderMailer.return_quote_email(quote,provider).deliver 
                #   end                            
                # else
                  shortlink = Googl.shorten("#{APP_CONFIG.base_url}/users/#{quote.user.username}/financialsettings").short_url
                  message = "Krediniz bitmistir. #{shortlink} adresinden kredi satin alabilsiniz. Kredi aldiktan sonra bu mesaja 'Evet' cevabi verebilirsiniz."
                  if send_multi_sms([provider.business_phone] ,[message],["NOCREDIT"], "nocredit", quote.id)
                    incoming.answered = true
                    outgoing.answered = true
                    outgoing.save!
                    incoming.save!
                    ProviderMailer.credit_email(provider).deliver 
                  end
                # end  
              end
            end
          end
        end
      elsif incoming.type == "quotedo" 
        provider_outgoing = Sms.where(:phone=> incoming.phone, :answered=>false,
                                      :incoming=>false, :type=>"quotegiven",
                                      :created_at.gt => (Time.now - 24.hours))  
        if provider_outgoing.present?
          provider_outgoing.each do |outgoing|
            if (outgoing.return_word == incoming.return_word.upcase) && incoming.answered ==false
              quote = Quote.find_by(:_id=>outgoing.quote_id, :call_with_phone => true)
              provider = Provider.find_by(:business_phone=>incoming.phone,:quote_ids=>quote.id)
              if quote.present? && provider.present?
         
                shortlink = Googl.shorten("#{APP_CONFIG.base_url}/users/#{quote.user.username}").short_url    
                message = "Hizmetkutusunu tercih ettiğiniz için teşekkürler. Şu kısa soruyu cevaplayarak diğer kişilere yardım edebilir ve ipad çekilişine katılabilirsiniz; Aldığınız hizmetin kalitesi ve fiyatına göre bu hizmet sağlayıcıya 5 üzerinden kaç puan verirsiniz ve yorumunuz ne olur? Ornek: '5 çok iyi iş çıkardılar'. (#{shortlink})"
                if send_multi_sms([quote.user.telephone], [message], ["Evet Evet Evet"],"referencerequest", quote.id)
                  incoming.answered = true
                  outgoing.answered = true
                  outgoing.save!
                  incoming.save!
                  UserMailer.comment_email(quote).deliver 
                end
              end
            end
          end
        end
      elsif incoming.type == "userreference"  
       user_outgoing = Sms.where(:phone=> incoming.phone,  :answered=>false,
                                    :incoming=>false, :type=>"referencerequest",
                                    :created_at.gt => (Time.now - 24.hours)) 
        if user_outgoing.present?
          user_outgoing.each do |outgoing|     
            if  incoming.answered ==false
              quote = Quote.find_by(:_id=>outgoing.quote_id, :call_with_phone => true)
              provider = Provider.find_by(:business_phone=>incoming.phone,:quote_ids=>quote.id)
              if quote.present? && provider.present?
                answers = incoming.return_word.upcase.split
                rating = {}
                array = ["servicerating", "pricerating", "speedrating"]
                answers.each_with_index do |answer, index|
                  if answer == "EVET"                
                    rating["#{array[index]}"]="1"
                  else
                    rating["#{array[index]}"]="-1"
                  end
                end
                rating["comment"]= ""
                Reference.update_reference_by_sms(quote, provider, rating)                
                incoming.answered = true
                outgoing.answered = true
                outgoing.save!
                incoming.save!  
              end                
            end
          end
        end
      else
        #else what   
     # notify_provider_correct_yes: "Lutfen evet cevabi verdiginizden emin olunuz."
      end
  end
   
  
  def match_freq(exprs, strings)
    rs, ss, f = exprs.split.map{|x|Regexp.new(x)}, strings.split, {}
    rs.each{|r| ss.each{|s| f[r] = f[r] ? f[r]+1 : 1 if s=~r}}
    [f.values.inject(0){|a,x|a+x}, f, f.size]
  end
  
  
   def add(key_value)
    key_value.each do |key, value|
      @hash[key] = value
    end
    self
  end

  
  
  end
