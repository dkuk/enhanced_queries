# issue_patch.rb
require_dependency 'query'

module EnhancedQueriesQueryPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

	# Same as typing in the class 
    base.class_eval do
		belongs_to :query_category, :class_name => 'QueryCategory', :foreign_key => 'category_id'
		#before_save :link_category
	end	
    

  end

  module ClassMethods   
    # Methods to add to the Issue class
  end

  module InstanceMethods
    # Methods to add to specific issue objects
	#def link_category
		#cat=QueryCategory.find_or_create_by_name("sdsdsd")
		#self.category_id=cat.id
		#cat.queries << self
		#cat.save
	#end
  end
  
  
end

