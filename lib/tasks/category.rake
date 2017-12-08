 
namespace :category do
  desc "insert category"
  task :task1 => :environment do  
		require 'spreadsheet'
		path = Rails.root.join('lib/tasks/import.xls')
		spreadsheet = Spreadsheet.open path
		sheet1 = spreadsheet.worksheet 0

		sheet1.each 1 do |sheet1_row|
		  row = sheet1_row
		  if Category.find_by(:title=> row[0]).blank?
		    level1 = Category.new(title: row[0], ancestors: [], parent: nil)
		    level1.save!
		  end
		  if Category.find_by(:title=> row[1]).blank?
		    level2 = Category.new(title: row[1], ancestors: [row[0]], parent: row[0])
		    level2.save!
		  end
		  if Category.find_by(:title=> row[2], :parent=>row[1]).blank?
		    level3 = Category.new(title: row[2], ancestors: [ row[0], row[1]], parent: row[1])
		    level3.save!
		  end
		  if Category.find_by(:title=> row[3] , :parent=>row[2]).blank?
		    level4 = Category.new(title: row[3], ancestors: [row[0],row[1], row[2]], parent: row[2])
		    level4.save!
		    variations = row[4].to_s.split
		    base_prices = row[9].to_s.split
		    duration = row[10].to_s.split
		    var =[]
		    variations.each do |v|
		    	if v.include? '-'
		        var << v.gsub!('-',' ')
		      else
		      	var << v
		      end
		    end
		    level4.business_function = BusinessFunction.new
		    level4.business_function.function = row[5].to_s
		    level4.business_function.category_tree = (row[1].to_s+"/"+row[2].to_s+"/"+row[3].to_s)
		    level4.business_function.unit = row[6].to_s
		    level4.business_function.eco = row[7].to_s
		    level4.business_function.pto = row[8].to_s
		    level4.business_function.onsite = false
		    level4.business_function.save!

		    var.each_with_index do |v, index|
		      level4.business_function.variations.create(variation: v, base_price: base_prices[index], duration: duration[index].to_i)
		    end 
		  end
		end
	end
end