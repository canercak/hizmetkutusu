namespace :address do
  desc "insert address"
  task :task1 => :environment do 
	require 'roo' 
	spreadsheet = Roo::Excelx.new("/app/lib/categories/address_minix.xlsx") 
	(2..spreadsheet.sheet(0).last_row).map do |i|
	  page1_row = Array[spreadsheet.row(i)][0]
		address = Address.new(title: page1_row[1])
		address.save!
		(2..spreadsheet.sheet(1).last_row).map do |i|
			page2_row = Array[spreadsheet.row(i)][0]
				if page1_row[0] == page2_row[1]
	         Address.new(title: page2_row[2], ancestors:[page1_row[1]], parent: page1_row[1]).save! 
					 (2..spreadsheet.sheet(2).last_row).map do |i|
	           page3_row = Array[spreadsheet.row(i)][0]
	           if page2_row[0] == page3_row[2]
	           	 Address.new(title: page3_row[3], ancestors:[page1_row[1], page2_row[2]], parent: page2_row[2], postcode: page3_row[4])
						 	 (2..spreadsheet.sheet(3).last_row).map do |i|
						 	 	 page4_row = Array[spreadsheet.row(i)][0]
						 	 	 if page3_row[0] == page4_row[3]
						 	 	 		 Address.new(title: page4_row[3], ancestors:[page1_row[1], page2_row[2], page3_row[3]], parent: page3_row[3]).save!
						 	 	 end
						 	 end
						 end 
					 end
				end
			end
		end 
	end
end 
 