require 'range_with_gaps'
require 'range_with_gaps/core_ext/range'
class BlockedHour
  include Mongoid::Document 
  embedded_in :provider
  field :start_date, :type=> DateTime 
  field :end_date, :type=> DateTime
  field :block_reason
  field :category_id, :type => Array
  field :staff_ids, :type => Array

  def self.blocked_days(provider, prices)
    date_range= ApplicationController.helpers.calculate_date_range 
    blocks = BlockedHour.get_blocks(provider,prices, date_range[0],date_range[1]) 
  	disabled_days = []
  	date_range[0].upto(date_range[1]) do |date|
 			bh = provider.business_hours[ApplicationController.helpers.business_hour_from_wday(date.wday)]
			bday_range = ApplicationController.helpers.get_business_day_range(date, bh["timeFrom"], bh["timeTill"])  
      bday_f = bday_range.to_a.first.first.to_i
      bday_l = bday_range.to_a.first.last.to_i 
      blocked_date = blocks[0][date]
			reserved_date = blocks[1][date] 
			disabled = nil
	 		if blocked_date.present? && reserved_date.blank? 
        disabled = BlockedHour.iterate_blocks(bh["isActive"],blocked_date,bday_range, bday_f, bday_l,blocks[2]) 
      elsif blocked_date.blank? && reserved_date.present? 
        disabled = BlockedHour.iterate_reserved(bh["isActive"],reserved_date,bday_range, bday_f, bday_l,blocks[2])
      elsif blocked_date.present? && reserved_date.present? 
     		disabled = BlockedHour.iterate_multiple(bh["isActive"],blocked_date,reserved_date,bday_range, bday_f, bday_l,blocks[2]) 
 	 		else
        disabled = false
 	 		end 
			if ((disabled == true) || (disabled == false && bh["isActive"] == false))
				disabled_days << date 
 			end  
 		end
		return  disabled_days  
	end


	def self.iterate_blocks(bh_active,blocked_date,bday_range, bday_f, bday_l, work_dur)
    blocked_range = BlockedHour.range_withgaps(blocked_date) 
		return true if (BlockedHour.find_available_hours(blocked_range, bday_f, bday_l, work_dur).count == 0)
  	return true if (bh_active == true && (bday_range.size == blocked_range.size))
	  return false
	end


	def self.iterate_reserved(bh_active,reserved_date,bday_range, bday_f, bday_l, work_dur) 
    reserved_range = BlockedHour.range_withgaps(reserved_date) 
		return true if (BlockedHour.find_available_hours(reserved_range, bday_f, bday_l, work_dur).count == 0)
  	return true if ((bh_active == true && (bday_range.size == reserved_range.size)) || 
  									(bh_active == false && bday_range.size == reserved_range.size)) 
	  return false 
	end

	def self.iterate_multiple(bh_active,blocked_date,reserved_date,bday_range, bday_f, bday_l, work_dur)
    blocked_range = BlockedHour.range_withgaps(blocked_date) 
		reserved_range = BlockedHour.range_withgaps(reserved_date) 
		all_range = blocked_range  | reserved_range
		return true if  (BlockedHour.find_available_hours(all_range, bday_f, bday_l, work_dur).count == 0)
  	return true if ((bh_active == true && (bday_range.size == all_range.size)) || 
  									(bh_active == false && bday_range.size == all_range.size)) 
	  return false 
	end
 
 	def self.range_withgaps(range_date)
		range = nil
		range_date.each do |date| 
      if range.blank?
				range = RangeWithGaps.new date.start_date.in_time_zone.to_i...date.end_date.in_time_zone.to_i
			else
				range.add date.start_date.in_time_zone.to_i...date.end_date.in_time_zone.to_i
			end 
 		end
 
		return range
	end


  def self.get_blocks(provider, prices, start_d, end_d)
    workdones = provider.workdones.where(:"prices._id".in=>prices)
    category_ids = workdones.map{|w| w.category_id}
    work_dur =  workdones.map{|w| w.prices.map { |p| p.duration}.reduce(:+)}.reduce(:+)
    business_hours = provider.business_hours
    eligible_staff =provider.workdones.map{|w| w.prices.map{|p| p.staff_ids if prices.include?(p._id) }}.reduce(:+).compact.reduce(:+)
    blocked_hours = provider.blocked_hours.where(:category_id.in=>category_ids,
                                                 :start_date.gte => start_d,
                                                 :end_date.lte => end_d) 
    categories = Category.where(:_id.in =>category_ids)
    ancestors = categories.map {|c| c.ancestors }.reduce(:+).uniq
    anc_cats = Category.where(:title.in=> ancestors).to_a.map{|c| c._id}
    parent_blocks = provider.blocked_hours.where(:category_id.in=>anc_cats,
                                                 :start_date.gte => start_d,
                                                 :end_date.lte => end_d) 
    all_blocks = blocked_hours + parent_blocks
    blocked  = all_blocks.group_by {|w| w.start_date.to_date}
    reservations = provider.quotes.where(:"reservations.price_ids".in => prices,
                                         :"reservations.start_date".gte => start_d, 
                                         :"reservations.end_date".lte => end_d).map{|q| q.reservations[0]}
    reserved = reservations.group_by {|w| w.start_date.to_date}  
    return [blocked, reserved,work_dur]
  end 

	def self.get_available_hours(provider, prices, date)
    available_hours = []
    unavail_range = nil
    blocks = BlockedHour.get_blocks(provider,prices, date.beginning_of_day,date.end_of_day) 
    bh = provider.business_hours[ApplicationController.helpers.business_hour_from_wday(date.wday)] 
    bday_range = ApplicationController.helpers.get_business_day_range(date, bh["timeFrom"], bh["timeTill"])  
    bday_f = bday_range.to_a.first.first.to_i
    bday_l = bday_range.to_a.first.last.to_i 
    blocked_date = blocks[0][date.to_date]
    reserved_date = blocks[1][date.to_date]  
    if blocked_date.present? && reserved_date.blank? 
      unavail_range  = BlockedHour.range_withgaps(blocked_date) 
    elsif blocked_date.blank? && reserved_date.present? 
      unavail_range  = BlockedHour.range_withgaps(reserved_date) 
    elsif blocked_date.present? && reserved_date.present? 
      unavail_range  =  BlockedHour.range_withgaps(blocked_date) | BlockedHour.range_withgaps(reserved_date)
    else 
      (bday_f..bday_l).step(30.minute) do |half_hour|
        unless (half_hour == bday_l)
          if (half_hour + blocks[2].minute) <= bday_l 
             available_hours << half_hour
          end
        end
      end
      return ApplicationController.helpers.half_hour_to_s(available_hours)
    end  
    return BlockedHour.find_available_hours(unavail_range,bday_f,bday_l, blocks[2]) 
	end


  def self.find_available_hours(unavail_range,bday_f,bday_l, work_dur)  
    available_hours = []
    prev_b_last = nil
    unavail_arr = unavail_range.to_a
    unavail_arr.each do |block|
      block_f = block.first.to_i
      block_l = block.last.to_i  
      if unavail_arr.first == block
        (bday_f..block_f).step(30.minute) do |half_hour|
          unless (half_hour == block_f) 
            if (half_hour + "#{work_dur}".to_i.minute) <= block_f 
              available_hours << half_hour
            end
          end
        end
        if unavail_arr.count == 1
          (block_l..bday_l).step(30.minute) do |half_hour|
            unless (half_hour == bday_l)
              if (half_hour + "#{work_dur}".to_i.minute) <= bday_l 
                available_hours << half_hour
              end
            end
          end 
        end
      elsif unavail_arr.last == block
        (prev_b_last..block_f).step(30.minute) do |half_hour|
          unless (half_hour == block_f)
            if (half_hour + "#{work_dur}".to_i.minute) <= block_f 
              available_hours << half_hour
            end
          end
        end
        (block_l..bday_l).step(30.minute) do |half_hour|
          unless (half_hour == bday_l)
            if (half_hour + "#{work_dur}".to_i.minute) <= bday_l 
              available_hours << half_hour
            end
          end
        end 
      else
        (prev_b_last..block_f).step(30.minute) do |half_hour|
          unless (half_hour == block_f)
            if (half_hour + "#{work_dur}".to_i.minute) <= block_f 
              available_hours << half_hour
            end
          end
        end
      end
      prev_b_last = block_l
    end 
    return ApplicationController.helpers.half_hour_to_s(available_hours)  
  end 
 
  def self.match_business_hours(provider,events, blocks, from, to)
    bh = provider.business_hours
    bh_range = ApplicationController.helpers.calendar_range(provider)
    blocked_days = blocks.map{|b| b.start_date.to_date}
    event_days = events.to_a.map{|b| b.start_date.to_date}
    blocked_hours = []
    (from.to_i..to.to_i).step(1.day) do |day| 
      date = Time.zone.at(day).to_date 
      bhours = bh[ApplicationController.helpers.business_hour_from_wday(date.wday)]  
      
      bday_range = ApplicationController.helpers.get_business_day_range(date, bhours["timeFrom"], bhours["timeTill"])  
      bday_f = Time.zone.at(bday_range.to_a.first.first)
      bday_l = Time.zone.at(bday_range.to_a.first.last)
      if !(blocked_days.include? date) && !(event_days.include? date) && bhours["isActive"]==false 
        blocked_hours << [bday_f, bday_l, "çalışmadığınız gün"] 
      elsif !(blocked_days.include? date) && !(event_days.include? date) && bhours["isActive"]==true 
        min_from = (date.beginning_of_day+bh_range[0].hours)
        min_to = (date.beginning_of_day+bh_range[1].hours)
        if bday_f.to_i > min_from.to_i
          blocked_hours << [min_from, bday_f, "çalışmadığınız gün"]
        end
        if bday_l.to_i < min_to.to_i
          blocked_hours << [bday_l, min_to, "çalışmadığınız gün"]
        end
      elsif ((blocked_days.include? date) || (event_days.include? date)) && bhours["isActive"]==false 
       
        if blocked_days.include? date  
          days_blocks = []
          days = blocked_days.each_index.select{|i| blocked_days[i] == date} 
          days.count.times do |index|
            block = blocks[days[index]]
            days_blocks << [block.start_date.in_time_zone, block.end_date.in_time_zone, block.block_reason]
          end
          blocked_hours.concat(days_blocks)
        end
      else
        days_blocks = []
        if blocked_days.include? date  
          days = blocked_days.each_index.select{|i| blocked_days[i] == date} 
          days.count.times do |index|
            block = blocks[days[index]]
            days_blocks << [block.start_date.in_time_zone, block.end_date.in_time_zone, block.block_reason]
          end
          block_range = RangeWithGaps.new
          days_blocks.each do |day_b|
            block_range.add day_b[0].to_i...day_b[1].to_i
          end 
          blocked_hours.concat(days_blocks)
        end 

 


 ######################

        days_events = []
        if event_days.include? date  
          days = event_days.each_index.select{|i| event_days[i] == date} 
          days.count.times do |index|
            event = events[days[index]]
            days_events << [event.start_date.in_time_zone, event.end_date.in_time_zone]
          end
          event_range = RangeWithGaps.new
          days_events.each do |day_b|
             event_range.add day_b[0].to_i...day_b[1].to_i
          end 
        end 
        hours_may_blocked= []
        min_from = (date.beginning_of_day+bh_range[0].hours)
        min_to = (date.beginning_of_day+bh_range[1].hours)
        if bday_f.to_i > min_from.to_i
          hours_may_blocked << [min_from, bday_f, "çalışmadığınız gün"]
        end
        if bday_l.to_i < min_to.to_i
          hours_may_blocked << [bday_l, min_to, "çalışmadığınız gün"]
        end
        if hours_may_blocked.present?
          may_block_range = RangeWithGaps.new
          hours_may_blocked.each do |day_b|
            may_block_range.add day_b[0].to_i...day_b[1].to_i
          end 
        end

        hours_to_block = []
        may_block_range.to_a.each_with_index do |mb, index|
          br = block_range.to_a[index]
          unless  mb  === br 
            hours_to_block << [Time.at(mb.first).in_time_zone, Time.at(mb.last).in_time_zone, "çalışmadığınız gün"]
          end
        end
        if hours_to_block.present?
          blocked_hours.concat(hours_to_block)
        end  

############################


      end
    end 
 
    return blocked_hours
  end
end
 