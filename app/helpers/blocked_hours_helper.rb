module BlockedHoursHelper

	def calculate_date_range
		start_day = Time.zone.now 
		end_day =  Time.zone.now + 2.months
		return [start_day.to_date, end_day.to_date]
	end

	def check_duration_ok(bday_duration, work_duration,duration)
		disabled = false
		if (work_duration + duration) > bday_duration
			disabled = true
		end
		return disabled
	end

	def get_business_day_range(date,from, till)
 
	 start_d = date.beginning_of_day + "#{Time.parse(from).hour}".to_i.hours
	 end_d = date.beginning_of_day + "#{Time.parse(till).hour}".to_i.hours
	 return RangeWithGaps.new start_d.to_i...end_d.to_i
	end

	def half_hour_to_s(available_hours)
		return available_hours.map {|h| Time.zone.at(h).strftime('%H:%M')}
	end

	def calculate_half_hours(date)
		minutes = []
    (date[0].to_i...date[1].to_i).step(30.minutes).each_with_index do |min, index|
      unless index == 0
        minutes << Time.at(min).utc
      end
    end  
    return minutes
	end

	def map_blocks_with_hours(blocks, half_hours)
		return blocks.map {|b| b if ((half_hours.include? b.start_date)  || (half_hours.include? b.end_date))}.compact
	end
 

end
