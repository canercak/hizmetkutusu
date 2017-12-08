module ReservationsHelper
	def calendar_dates(date,startd,endd)
		d =  Time.zone.parse(date)
		st= Time.zone.parse(startd)
		et = Time.zone.parse(endd)
		start_date = Time.zone.parse(Time.zone.local(d.year, d.month, d.day, st.hour, st.min, st.sec).strftime('%Y-%m-%d %H:%M:%S %Z')).utc 
		end_date = Time.zone.parse(Time.zone.local(d.year, d.month, d.day, et.hour, et.min, et.sec).strftime('%Y-%m-%d %H:%M:%S %Z')).utc
		return [start_date, end_date]
	end

	def set_color(status, customer_originated)
		color = nil
		if status == 1
			color = "#009933"  
		elsif status == 2
			color = "#CC0000"
		else
			if customer_originated == true 
				color = "orange"
			else
				color = "#1796b0"
			end
		end
		return color				
	end


  def update_status_scores(quote,reservation)
    type = nil
    status = reservation.status
    if status == 0 && reservation.customer_originated == false
      type = "provider_reservation"
    elsif status == 1 && reservation.customer_originated == false
       type ="provider_done" 
    elsif status == 1 && reservation.customer_originated == true
       type ="customer_done"       
    elsif status == 3 
      type ="provider_cancel"
    else
    end 
    Workdone.update_scores(type, quote, quote.provider, nil) 
  end



	def get_titles(categories,blocks,events)
		titles =  []
		cats = [] 
		if blocks.present? 
			cats = blocks.map{|b| b.category_id}.reduce(:+)
		end
		if events.present?
			vars = events.map{|b| b.variation_ids}.reduce(:+)
			cats = Category.where(:"business_function.variations._id".in =>vars).map(&:_id) 
		end
		actual_cats = categories & cats
		return Category.where(:_id.in=>actual_cats).map(&:title).join(', ')
	end
end