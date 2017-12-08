var I18n = I18n || {};
I18n.translations = {
    "en": {
        "boolean": {
            "true": "Yes",
            "false": "No"
        },
        "date": {
            "abbr_day_names": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            "abbr_month_names": [null, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            "day_names": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
            "formats": {
                "default": "%Y-%m-%d",
                "long": "%B %d, %Y",
                "short": "%b %d",
                "full_day": "%A %B %e",
                "birthday": "%B %-d, %Y",
                "month_year": "%B %Y"
            },
            "month_names": [null, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            "order": ["month", "day", "year"]
        },
        "time": {
            "am": "am",
            "formats": {
                "default": "%a, %d %b %Y %I:%M:%S %p %z",
                "long": "%B %d, %Y %I:%M %p",
                "short": "%d %b %I:%M %p",
                "time_only": "%I:%M %p"
            },
            "pm": "pm",
            "ampm": true
        },
        "datetime": {
            "distance_in_words": {
                "about_x_hours": {
                    "one": "about 1 hour",
                    "other": "about %{count} hours"
                },
                "about_x_months": {
                    "one": "about 1 month",
                    "other": "about %{count} months"
                },
                "about_x_years": {
                    "one": "about 1 year",
                    "other": "about %{count} years"
                },
                "almost_x_years": {
                    "one": "almost 1 year",
                    "other": "almost %{count} years"
                },
                "half_a_minute": "half a minute",
                "less_than_x_minutes": {
                    "one": "less than a minute",
                    "other": "less than %{count} minutes"
                },
                "less_than_x_seconds": {
                    "one": "less than 1 second",
                    "other": "less than %{count} seconds"
                },
                "over_x_years": {
                    "one": "over 1 year",
                    "other": "over %{count} years"
                },
                "x_days": {
                    "one": "1 day",
                    "other": "%{count} days"
                },
                "x_minutes": {
                    "one": "1 minute",
                    "other": "%{count} minutes"
                },
                "x_months": {
                    "one": "1 month",
                    "other": "%{count} months"
                },
                "x_seconds": {
                    "one": "1 second",
                    "other": "%{count} seconds"
                }
            },
            "prompts": {
                "day": "Day",
                "hour": "Hour",
                "minute": "Minute",
                "month": "Month",
                "second": "Seconds",
                "year": "Year"
            },
            "formats": {
                "message": "%A %B %e, %I:%M"
            }
        },
        "javascript": {
            "no_quotes_found": "No quotes found",
            "an_error_occurred": "Ops! An error occurred while searching for quotes.",
            "not_found": "Route not found",
            "zero_results": "No results",
            "write_description_first": "Please write description",
            "select_service_first": "Please select service",            
            "enter_keyword": "Please enter keyword to search",
            "business_name": "Official Business Name*",       
            "enter_address_first": "Please enter your location",     
            "tax_number": "Tax Number*",
            "person_name": "Name and Lastname*",
            "pin" : "Social Security Number*"
        },
        "shared": {
            "navbar": {
                "language": "Language",
                "account_settings": "Account Settings",
                "new_quote": "Get New Quote!",
                "quote_history": "Quote History",
                "see_all_messages": "See All",
                "no_new_messages": "No new messages",
                "please_select": "Please select",
                "more_characters": "more characters",
                "you_can_only_select": "You can only select",
                "maxium_file_size": "You can only select images with maxium 5 mb size",
                "image_extensions": "You can only select images with extensions jpg,jpeg,bmp,tif,png",
                "item": "items",
                "search_distance": "km far from me",
                "no_matches_found": "No matches found",
                "result_not_found": "%We have searched up to {distance} km and could not find any results. Please slide the little blue square right to look further.",
                "loading_more_results": "Loading...",
                "searching": "Searching..."
            }
        },
        "templates": {
            "quotes": {
                "read_more": "Read more",
                "show_on_map": "Show on map",
                "facebook_verified": "Verified on Facebook",
                "edit_provider": "Edit",
                "service_score": "Service Score",
                "price_score": "Price Score",
                "likes": "Beğeni",
                "checkin": "Ziyaretçi",
                "follow": "Takipçi",
                "speed_score": "Speed Score",
                "gave_service": "Given Service",
                "appname_score": "Hizmetkutusu score",
                "about": "About",
                "references": "References",
                "certificates": "Certificates",
                "photos": "Photos"
            }
        },
        "mongoid": {
            "attributes": {
                "quote": {
                    "title": "Title",
                    "description": "Description",
                }
            }
        }
    },
    "az": {
        "boolean": {
            "true": "S\u00ec",
            "false": "Hayır"
        },
        "date": {
            "abbr_day_names": ["Paz","Paz", "Sal", "Çar", "Per", "Cum", "Cmt"],
            "abbr_month_names": [null, "Ock", "Şbt", "Mar", "Nis", "May", "Haz", "Tem", "Ags", "Eyl", "Ekm", "Ksm", "Arl"],
            "day_names": ["Pazar","Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"],
            "formats": {
                "default": "%d-%m-%Y",
                "long": "%d %B %Y",
                "short": "%d %b",
                "full_day": "%A %e %B",
                "birthday": "%-d %B %Y",
                "month_year": "%B %Y"
            },
            "month_names": [null, "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"],
            "order": ["day", "month", "year"]
        },
        "time": {
            "am": "am",
            "formats": {
                "default": "%a %d %b %Y, %H:%M:%S %z",
                "long": "%d %B %Y %H:%M",
                "short": "%d %b %H:%M",
                "time_only": "%H:%M"
            },
            "pm": "pm",
            "ampm": false
        },
        "datetime": {
            "distance_in_words": {
                "about_x_hours": {
                    "one": "1 saat",
                    "other": "nerdeyse %{count} gün"
                },
                "about_x_months": {
                    "one": "1 ay",
                    "other": "nerdeyse %{count} ay"
                },
                "about_x_years": {
                    "one": "1 yıl",
                    "other": "nerdeyse %{count} yıl"
                },
                "almost_x_years": {
                    "one": "1 yıl",
                    "other": "nerdeyse %{count} yıl"
                },
                "half_a_minute": "yarın dakika",
                "less_than_x_minutes": {
                    "one": "1 dakikadan az",
                    "other": "%{count} dakikadan az "
                },
                "less_than_x_seconds": {
                    "one": "1 dakikadan az",
                    "other": "%{count} saniye"
                },
                "over_x_years": {
                    "one": "yıl",
                    "other": " %{count} yıl"
                },
                "x_days": {
                    "one": "1 gün",
                    "other": "%{count} gün"
                },
                "x_minutes": {
                    "one": "1 dakika",
                    "other": "%{count} dakika"
                },
                "x_months": {
                    "one": "1 ay",
                    "other": "%{count} mesi"
                },
                "x_seconds": {
                    "one": "1 saniye",
                    "other": "%{count} saniye"
                }
            },
            "prompts": {
                "day": "gün",
                "hour": "saat",
                "dakika": "dakika",
                "month": "ay",
                "second": "saniye",
                "year": "yıl"
            },
            "formats": {
                "message": "%A %e %B, %H:%M"
            }
        },
        "javascript": {
            "no_quotes_found": "Hiç kayıt bulunamadı",
            "an_error_occurred": "Sistemde bir hata oldu.",
            "not_found": "Bulunamadı",
            "zero_results": "Hiç sonuç yok",
            "write_description_first": "Lütfen istediğiniz hizmeti kısa açıklayınız",
            "select_service_first": "Lütfen almak istediğiniz hizmeti seçiniz",
            "enter_keyword": "Lütfen aramak istediğiniz kelimeyi yazınız",
            "business_name": "Ticari Ünvanınız*",
            "enter_address_first": "Lütfen hizmetin verileceği konumu giriniz",
            "tax_number": "Vergi numaranız*",
            "person_name": "Adınız ve Soyadınız*",
            "pin": "TC Kimlik Numaranız*"
        },
        "shared": {
            "navbar": {
                "language": "Dil",
                "account_settings": "Hesap Ayarları",
                "new_quote": "Yeni Fiyat Al!",
                "quote_history": "Teklif Geçmişim",
                "see_all_messages": "Tüm Mesajları Gör",
                "no_new_messages": "Yeni Mesajınız Yok",
                "please_select": "Lütfen hizmetle ilgili",
                "more_characters": "harf daha yazınız",
                "you_can_only_select": "Sadece",
                "item": "hizmet seçebilirsiniz",
                "search_distance": "km uzağıma kadar arama yapılsın",
                "no_matches_found": "Hiçbir hizmet türü bulunamadı",
                "result_not_found": "%{distance} km uzağınıza kadar hiçbir hizmet sağlayıcı bulamadık. Daha uzağınızdakileri görmek için küçük mavi kareyi sağa doğru kaydırınız.",
                "loading_more_results": "Yükleniyor...",
                "searching": "Aranıyor..."
            }
        },
        "templates": {
            "quotes": {
                "read_more": "Daha Fazla",
                "show_on_map": "Haritada Göster",
                "facebook_verified": "Facebook Onaylı",
                "edit_provider": "Düzenle",
                "service_score": "Kalite Puanı",
                "givequote": "Teklif Versin",
                "price_score": "Fiyat Puanı",
                "speed_score": "Zaman Puanı",
                "gave_service": "Hizmet Vermiş",
                "appname_score": "Hizmetkutusu Puanı",
                "about": "Hakkında",
                "likes": "Beğeni",
                "checkin": "Ziyaretçi",
                "follow": "Takipçi",
                "references": "Yorumları",
                "certificates": "Sertifikaları",
                "photos": "Fotografları"
            }
        },
        "mongoid": {
            "attributes": {
                "quote": {
                    "title": "Başlık",
                    "description": "Açıklama"
                }
            }
        }
    }
    ,
    "tr": {
        "boolean": {
            "true": "S\u00ec",
            "false": "Hayır"
        },
        "date": {
            "abbr_day_names": ["Paz","Pzt", "Sal", "Çar", "Per", "Cum", "Cmt"],
            "abbr_month_names": [null, "Ock", "Şbt", "Mar", "Nis", "May", "Haz", "Tem", "Ags", "Eyl", "Ekm", "Ksm", "Arl"],
            "day_names": ["Pazar","Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"],
            "formats": {
                "default": "%d-%m-%Y",
                "long": "%d %B %Y",
                "short": "%d %b",
                "full_day": "%A %e %B",
                "birthday": "%-d %B %Y",
                "month_year": "%B %Y"
            },
            "month_names": [null, "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"],
            "order": ["day", "month", "year"]
        },
        "time": {
            "am": "am",
            "formats": {
                "default": "%a %d %b %Y, %H:%M:%S %z",
                "long": "%d %B %Y %H:%M",
                "short": "%d %b %H:%M",
                "time_only": "%H:%M"
            },
            "pm": "pm",
            "ampm": true
        },
        "datetime": {
            "distance_in_words": {
                "about_x_hours": {
                    "one": "1 saat",
                    "other": "nerdeyse %{count} gün"
                },
                "about_x_months": {
                    "one": "1 ay",
                    "other": "nerdeyse %{count} ay"
                },
                "about_x_years": {
                    "one": "1 yıl",
                    "other": "nerdeyse %{count} yıl"
                },
                "almost_x_years": {
                    "one": "1 yıl",
                    "other": "nerdeyse %{count} yıl"
                },
                "half_a_minute": "yarın dakika",
                "less_than_x_minutes": {
                    "one": "1 dakikadan az",
                    "other": "%{count} dakikadan az "
                },
                "less_than_x_seconds": {
                    "one": "1 dakikadan az",
                    "other": "%{count} saniye"
                },
                "over_x_years": {
                    "one": "yıl",
                    "other": " %{count} yıl"
                },
                "x_days": {
                    "one": "1 gün",
                    "other": "%{count} gün"
                },
                "x_minutes": {
                    "one": "1 dakika",
                    "other": "%{count} dakika"
                },
                "x_months": {
                    "one": "1 ay",
                    "other": "%{count} mesi"
                },
                "x_seconds": {
                    "one": "1 saniye",
                    "other": "%{count} saniye"
                }
            },
            "prompts": {
                "day": "gün",
                "hour": "saat",
                "dakika": "dakika",
                "month": "ay",
                "second": "saniye",
                "year": "yıl"
            },
            "formats": {
                "message": "%A %e %B, %H:%M"
            }
        },
        "javascript": {
            "no_quotes_found": "Hiç kayıt bulunamadı",
            "an_error_occurred": "Sistemde bir hata oldu.",
            "not_found": "Bulunamadı",
            "zero_results": "Hiç sonuç yok",
            "write_description_first": "Lütfen istediğiniz hizmeti kısa açıklayınız",
            "select_service_first": "Lütfen almak istediğiniz hizmeti seçiniz",
            "select_variation_first": "Lütfen seçtiğiniz hizmetin türünü seçiniz",
            "enter_keyword": "Lütfen aramak istediğiniz kelimeyi yazınız",
            "business_name": "Ticari Ünvanınız*",
            "full_business_name": "Tam Ticari Ünvanınız*",
            "enter_address_first": "Lütfen hizmetin verileceği konumu giriniz",
            "enter_date_first": "Lütfen hizmeti almayı öngördüğünüz tarihi seçiniz",
            "tax_number": "Vergi numaranız*",
            "person_name": "Adınız ve Soyadınız*",
            "pin": "TC Kimlik Numaranız*"
        },
        "shared": {
            "navbar": {
                "language": "Dil",
                "account_settings": "Hesap Ayarları",
                "new_quote": "Yeni Fiyat Al!",
                "quote_history": "Teklif Geçmişim",
                "see_all_messages": "Tüm Mesajları Gör",
                "no_new_messages": "Yeni Mesajınız Yok",
                "please_select": "Lütfen hizmetle ilgili",
                "maxium_file_size": "En fazla 5 mb boyutunda resim seçebilirsiniz.",
                "image_extensions": "Sadece şu uzantıdaki resimleri seçebilirsiniz: jpg,jpeg,bmp,tif,png",
                "more_characters": "harf daha yazınız",
                "you_can_only_select": "Sadece",
                "item": "hizmet seçebilirsiniz",
                "search_distance": "km uzağıma kadar arama yapılsın",
                "no_matches_found": "Hiçbir sonuç bulunamadı",
                "result_not_found": "%{distance} km uzağınıza kadar hiçbir hizmet sağlayıcı bulamadık. Daha uzağınızdakileri görmek için küçük mavi kareyi sağa doğru kaydırınız.",
                "loading_more_results": "Yükleniyor...",
                "searching": "Aranıyor...",
                "searching_main_page": "İstediğiniz hizmeti buraya yazın; kalitesini ve fiyatını kıyaslayalım.",
                "pleasewait": "Lütfen bekleyiniz..." ,
                "problem_sending_sms": "Sms gönderirken bir hata oluştu. Lütfen girdiğiniz bilgileri kontrol ediniz" ,
                "problem_sending_request": "Sms sağlayıcımızla bağlantı kurarken bir hata oluştu. Lütfen daha sonra tekrar deneyiniz",
                "send_code_again": "Tekrar Gönder",
                "booking_first": "<b>%{fulltime}</b> tarihine <b>%{variation_names}</b> için randevu alıyorsunuz.",
                "estimated_duration": "Seçtiğiniz %{service_s} %{duration} sürecektir.",
                "booking_header": "<b>%{provider_name}<b> tarafından verilen <b>%{variation_names}</b> uygun zamanlar",
                "booking_second": "Ödeyeceğiniz tutar <b>%{sum_prices} TL</b>. Randevuyu onayladıktan sonra hizmet sağlayıcınız <b>%{provider}</b> sizinle iletişime geçecektir.",
                "booking_third": "Hizmet sağlayıcımızın iş durumuna ve diğer belirleyemediğimiz koşullara göre randevu saatinizde değişiklik olabilir. Hizmet sağlayıcımız sizi bu konuda haberdar edecektir.",
                "error_in_code": "Hatalı kod girdiniz.",
                "giving_service": "Hizmet mi veriyorsunuz?",
                "come_here": "Buraya Tıklayın",
                "selected": "kez teklif vermesi istenmiş",
                "done": "hizmet vermiş",
                "ukraine": "lütfen 11 karakter giriniz",
                "returned": "teklif vermiş"             
            }
        },
        "event": {
            "service": {
                "blank": "Lütfen hizmeti giriniz",
                "remote":"Seçtiğiniz hizmet için belirlediğiniz saat aralığı kapatılmış. Lütfen haftalık plandan kontrol ediniz."
            },
            "customer": {
                "blank": "Lütfen müşteriyi seçiniz"
            },
            "text": {
                "blank": "Lütfen randevu açıklamasını giriniz"
            },
            "event_block": {
                "blank": "Lütfen kapatmak istediğiniz hizmeti seçiniz",
                "remote": "Kapattığınız hizmet zmaanı"
            },
            "personel_block": {
                "blank": "Lütfen personeli seçiniz",
                "remote": "Kapattığınız hizmet zmaanı"
            }  
        },
        "provider":{
          "officialname":{
            "presence": "lütfen ticari ünvanınızı giriniz.",
            "too_long": "lütfen en fazla 50 karakterlik bir ünvan giriniz.",
            "too_short": "lütfen en az 5 karakterlik bir ünvan giriniz." 
          },
          "business_description":{
            "blank": "lütfen verdiğiniz hizmetler hakkında kısa bir açıklama giriniz.",
            "too_long": "girdiğiniz açıklama en fazla 500 karakter olmalıdır.",
            "too_short": "girdiğiniz açıklama en az 20 karakter olmalıdır." 
          },
          "provider_image":{
            "blank": "lütfen seçiniz.",
            "file_size": "En fazla 5mb olabilir",
            "file_type": "Resim formatı seçiniz"  
          },
          "category":{
            "blank": "lütfen verdiğiniz hizmetleri seçiniz.",
            "max": "lütfen en fazla 25 hizmet seçiniz"
          },
          "address":{
            "neigbor": "Semt seçiniz",
            "district": "İlçe seçiniz",
            "no_door": "Numarayı yazınız",
            "street": "Sokağı yazınız."
          },
          "tax_office":{
            "blank": "Lütfen vergi dairenizi giriniz" 
          },
          "tax_business_name":{
            "blank": "Lütfen resmi şirket adınızı giriniz."
          },
          "tax_fullname":{
            "blank": "Lütfen adınızı ve soyadınızı giriniz." 
          },
          "tax_pin":{
            "blank": "Lütfen TC Kimlik numaranızı giriniz",
            "uniqueness": "Tckimlik numarası sistemde kayıtlıdır. Lütfen doğru girdiğinizden emin olunuz.",
            "wrong_length": "11 rakamdan oluşmalıdır." 
          },
          "tax_number": {
            "blank": "Lütfen vergi numaranızı giriniz.",
            "uniqueness": "vergi numarası sistemde kayıtlıdır. Lütfen doğru girdiğinizden emin olunuz.",
            "wrong_length": "10 rakamdan oluşmalıdır." 
          },
          "business_email":{
            "blank": "Lütfen hizmet sağlayıcınıza ulaşmamız için e-posta giriniz.",
            "uniqueness": "girdiğiniz eposta sistemde başka birine kayıtlıdır. Lütfen doğru girdiğinizden emin olunuz.",
            "invalid": "lütfen e-posta adresinizi doğru girdiğinzden emin olunuz." 
          },
          "business_phone":{
            "blank": "Lütfen hizmet sağlayıcınıza ulaşmamız için cep telefonu giriniz.",
            "uniqueness": "girdiğiniz telefon sistemde başka birine kayıtlıdır. Lütfen doğru girdiğinizden emin olunuz.",
            "length": "11 rakamdan oluşmalıdır." 
          },
          "business_address":{
            "presence": "lütfen iş yerinizin adresini yazarak haritadan seçildiğinden emin olunuz." 
          }
        },
        "signup":{
          "name": "Lütfen isminizi giriniz",
          "password": {
            "required": "Lütfen şifrenizi giriniz.",
            "minlength": "Şifreniz en az 6 karakter olmalıdır.",
          },
          "password_confirmation": {
            "required": "Lütfen şifrenizi tekrar giriniz.",
            "minlength": "Şifreniz en az 6 karakter olmalıdır.",
            "equalTo": "Şifre tekrarınız şifrenizle aynı olmalıdır.",
          },
          "email":{
            "required": "Lütfen e-posta adresinizi giriniz.",
            "email": "Lütfen geçerli bir e-posta adresi giriniz.",
            "remote": "E-posta adresi sistemde kayıtlı, lütfen doğru girdiğinizden emin olunuz veya giriş yapınız."
          }
        },
        "templates": {
            "quotes": {
                "read_more": "Daha Fazla",
                "show_on_map": "Haritada Göster",
                "facebook_verified": "Facebook Onaylı",
                "edit_provider": "Düzenle",
                "service_score": "Kalite puanı",
                "givequote": "Teklif Versin",
                "take_star": "Yıldız aldı",
                "currency": " TL",
                "comment": "yorumda",
                "likes": "Beğeni",
                "checkin": "Ziyaretçi",
                "follow": "Takipçi",
                "no_comment": "Yorum bırakılmadı",
                "no_quote": "Randevu vermedi",
                "no_service": "Hizmet vermedi",
                "gave_service": "Hizmet verdi",
                "gave_quote": "Randevu verdi",
                "km_far":"km uzakta",
                "appname_score": "Hizmetkutusu Puanı",
                "verified": "Onaylı",
                "unverified": "Onaysız",
                "about": "Hakkında",
                "references": "Yorumları",
                "certificates": "Sertifikaları",
                "photos": "Fotoğrafları",
                "quotes": "Hizmetleri"
            }
        },
        "mongoid": {
            "attributes": {
                "quote": {
                    "title": "Başlık",
                    "description": "Açıklama"
                } 
            }
        }
    },
    "en": {
        "date": {
            "formats": {
                "default": "%Y-%m-%d",
                "short": "%b %d",
                "long": "%B %d, %Y"
            },
            "day_names": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
            "abbr_day_names": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            "month_names": [null, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            "abbr_month_names": [null, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            "order": ["year", "month", "day"]
        },
        "time": {
            "formats": {
                "default": "%a, %d %b %Y %H:%M:%S %z",
                "short": "%d %b %H:%M",
                "long": "%B %d, %Y %H:%M"
            },
            "am": "am",
            "pm": "pm"
        },
        "datetime": {
            "distance_in_words": {
                "half_a_minute": "half a minute",
                "less_than_x_seconds": {
                    "one": "less than 1 second",
                    "other": "less than %{count} seconds"
                },
                "x_seconds": {
                    "one": "1 second",
                    "other": "%{count} seconds"
                },
                "less_than_x_minutes": {
                    "one": "less than a minute",
                    "other": "less than %{count} minutes"
                },
                "x_minutes": {
                    "one": "1 minute",
                    "other": "%{count} minutes"
                },
                "about_x_hours": {
                    "one": "about 1 hour",
                    "other": "about %{count} hours"
                },
                "x_days": {
                    "one": "1 day",
                    "other": "%{count} days"
                },
                "about_x_months": {
                    "one": "about 1 month",
                    "other": "about %{count} months"
                },
                "x_months": {
                    "one": "1 month",
                    "other": "%{count} months"
                },
                "about_x_years": {
                    "one": "about 1 year",
                    "other": "about %{count} years"
                },
                "over_x_years": {
                    "one": "over 1 year",
                    "other": "over %{count} years"
                },
                "almost_x_years": {
                    "one": "almost 1 year",
                    "other": "almost %{count} years"
                }
            },
            "prompts": {
                "year": "Year",
                "month": "Month",
                "day": "Day",
                "hour": "Hour",
                "minute": "Minute",
                "second": "Seconds"
            }
        },
        "mongoid": null
    }
};

