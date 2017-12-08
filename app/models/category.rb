class Category
  include Mongoid::Document
 
  searchkick #  suggest: ["name"]  #suggest: true,misspellings: true
  #, highlight: true,  text_start: [:title],suggest: ["title"]
  embeds_one :business_function
  field :title
  field :ancestors, :type=> Array 
  field :parent
  #db.categories.ensureIndex( { ancestors: 1 } )
 

  def self.find_variations(category_ids) 
    categories = Category.where(:_id.in=> category_ids)
    variation_ids = [] 
    categories.to_a.each do |category|
      if category.ancestors.count == 3
        variation_ids << category.to_a.map { |c| c.business_function.variations}.map { |v| v}.reduce(:+).map{|x| x._id}
      else 
        children = Category.where(:ancestors=>category.title).where(:"business_function.variations".ne =>nil) 
        variation_ids << children.map { |c| c.business_function.variations}.map { |v| v}.reduce(:+).map{|x| x._id}
      end
    end
    result = variation_ids.reduce(:+)
    return result & result
  end

  def self.find_categories(variation_ids)
    return Category.where(:"business_function.variations._id".in=>variation_ids).uniq
  end

  def self.list_category_prices(provider, categories)
    grand_parents = categories.map {|a| a.ancestors[1] } & categories.map {|a| a.ancestors[1] }
    parents = categories.map {|a| a.ancestors[2] } & categories.map {|a| a.ancestors[2] }
    babies = categories.map {|a| a.title} 
    data = Jbuilder.encode do |json|
      json.data grand_parents.each do |grand_parent|
        json.text grand_parent
        json.children  Category.where(:parent=>grand_parent, :title.in=>parents).to_a do |parent|
          json.text parent.title 
            category = Category.where(:parent=>parent.title, :title.in=>babies) 
            variations = category.map{|c| c.business_function.variations.map {|v| v}}.reduce(:+)
            variation_ids = variations.map(&:_id)
            prices = provider.workdones.map{|w| w.prices.map{|p| p if variation_ids.include?(p.variation_id)}}.reduce(:+).compact
            json.children prices do |baby|
              variation = variations[variation_ids.index baby.variation_id]
              json.text variation.business_function.category.title + "  (" + variation.variation + " - " + baby.price.to_s + " TL)"
              json.id baby._id
            end
          end
        end
    end 
    return data 
  end

  def self.list_search_categories(categories)
    grand_parents = categories.map {|a| a.ancestors[1] } & categories.map {|a| a.ancestors[1] }
    parents = categories.map {|a| a.ancestors[2] } & categories.map {|a| a.ancestors[2] }
    babies = categories.map {|a| a.title} 
    data = Jbuilder.encode do |json|
      json.data grand_parents.each do |grand_parent|
        json.text grand_parent
        json.children  Category.where(:parent=>grand_parent, :title.in=>parents).to_a do |parent|
          json.text parent.title
          json.children  Category.where(:parent=>parent.title, :title.in=>babies).to_a do |baby|
            json.text baby.title 
            variations = baby.business_function.variations 
            json.children variations do |variation| 
              json.text baby.title + ": "+ variation.variation
              json.id variation._id
            end 
          end 
        end
      end
    end 
    return data 
  end


  def self.find_related(category_id)
    category = Category.find(category_id)
    related_categories = Array.new 
    if category.ancestors.count == 3
      related_categories << category._id
    else  
      related_categories << category._id
      cats = Category.where(:ancestors=>category.title).to_a
      cats.each do |cat|
        related_categories << cat._id
      end
    end 
    return related_categories
  end

  def self.find_parent_related(category_ids)
    categories = Category.where(:_id.in=>category_ids)
    related_categories = Array.new 
    categories.each do |category| 
      cats = Category.where(:title.in=>category.ancestors).map(&:_id)
      cats.each do |cat|
        related_categories << cat
      end
    end
    return related_categories && related_categories
  end

  def self.list_provider_categories(provider,categories)
    variation_ids,category_ids,related_categories = [],[],[] 
    if provider.present?
      variation_ids = provider.workdones.map{|w| w.prices.map{|p| p.variation_id if p.active == true}}.reduce(:+)
      category_ids = provider.workdones.where(:"prices.active"=>true).map(&:category_id).uniq
      related_categories = self.find_parent_related(category_ids)
    end
    grand_parents = categories.map {|a| a.ancestors[1] } & categories.map {|a| a.ancestors[1] }.compact
    parents = categories.map {|a| a.ancestors[2] } & categories.map {|a| a.ancestors[2] }.compact
    babies = categories.map {|a| a.title}.compact
    data = Jbuilder.encode do |json|
      json.array! grand_parents.each do |grand_parent|
        gp_id = Category.find_by(:title=>grand_parent)._id
        json.title grand_parent
        json.key gp_id
        json.folder true
        if related_categories.include? gp_id
          json.expanded true
        end
        json.children  Category.where(:parent=>grand_parent, :title.in=>parents).to_a do |parent|
          json.title parent.title
          json.key parent._id
          json.folder true 
          if related_categories.include? parent._id
            json.expanded true
          end
          json.children  Category.where(:parent=>parent.title, :title.in=>babies).to_a do |baby|
            variations = baby.business_function.variations 
            json.title baby.title
            json.key baby._id
            json.folder true 
            if category_ids.include? baby._id
              json.expanded true
            end
            json.children variations do |variation| 
              json.key variation._id
              json.title variation.variation
              if variation_ids.include? variation._id
                json.selected true
                json.extraClasses "fancytree-selected"
                json.expanded true
              else
                json.selected false                  
              end
            end
          end
        end
      end
    end 
    return data 
  end


end
