Fabricator(:category) do 
  title {"Kirpik Perması"}
  ancestors {["Tüm Hizmetler","Kişisel Bakım Hizmetleri", "Kirpik Bakımı"]} 
  parent { "Kirpik Bakımı"}

  after_create do 
	  if Category.find_by(:title=>"Kirpik Bakımı").blank?
	  Fabricate(:category, title: "Kirpik Bakımı", ancestors: ["Tüm Hizmetler", "Kişisel Bakım Hizmetleri" ],parent: "Kişisel Bakım Hizmetleri")
	  end
	  if Category.find_by(:title=>"Kişisel Bakım Hizmetleri").blank?
	  Fabricate(:category, title: "Kişisel Bakım Hizmetleri", ancestors: ["Tüm Hizmetler"],parent: "Tüm Hizmetler")
	  end
	  if Category.find_by(:title=>"Tüm Hizmetler").blank?
	  Fabricate(:category, title: "Tüm Hizmetler", ancestors: [ ],parent: nil)
	  end
	end


	
end

