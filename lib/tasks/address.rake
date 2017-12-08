namespace :insert_address do
  desc "insert address"
  task :insert => :environment do 
		require 'spreadsheet'
		spreadsheet = Spreadsheet.open "/home/caner/dev/hizmetkutusu/lib/categories/address_turkey.xls"
		sheet1 = spreadsheet.worksheet 0
		sheet2 = spreadsheet.worksheet 1
		sheet3 = spreadsheet.worksheet 2
		sheet4 = spreadsheet.worksheet 3
		address_array = []
		sheet1.rows.each do |sheet1_row|
		  Address.create(title: sheet1_row[1]) 
		  rows_p =  sheet2.rows.map{|x| x if x[1] == sheet1_row[0]}.compact
		  rows_p.each do |sheet2_row| 
		  	address_array << {:title=>sheet2_row[2], :ancestors => [sheet1_row[1]], :parent=> sheet1_row[1]} 
		  	rows_d =  sheet3.rows.map{|x| x if x[2] == sheet2_row[0]}.compact
		  	rows_d.each do |sheet3_row|
		  		address_array << {:title=> sheet3_row[3], :ancestors=>[sheet1_row[1], sheet2_row[2]], :parent=> sheet2_row[2], :postcode=> sheet3_row[4]}
					rows_n =  sheet4.rows.map{|x| x if x[3] == sheet3_row[0]}.compact
					rows_n.each do |sheet4_row|
		  			address_array << {:title=> sheet4_row[4], :ancestors => [sheet1_row[1], sheet2_row[2], sheet3_row[3]], :parent=> sheet3_row[3]} 
					end
					Address.create(address_array)
					address_array = []
				end
				Address.create(address_array)
				address_array = []
			end
			Address.create(address_array)
			address_array = []
		end  
	end
end 
	 