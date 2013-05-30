# issue_patch.rb
require_dependency 'query'

module EnhancedQueriesQueriesControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

	# Same as typing in the class 
    base.class_eval do
		if(Setting.plugin_enhanced_queries['enable'] == 'true')
			before_filter :link_category, :only => [:update, :create]
			before_filter :change_category, :only => [:edit]
		end
	end	
    

  end

  module ClassMethods   
    # Methods to add to the Issue class
  end

  module InstanceMethods
    # Methods to add to specific issue objects
	def link_category
		params[:query][:category_id]=QueryCategory.find_or_create_by_name(params[:query][:category_id]).id
	end
	
	def change_category
		if QueryCategory.find_by_id(@query.category_id)
			@query.category_id=QueryCategory.find_by_id(@query.category_id).name;
		else
			@query.category_id="";
		end
	end	
  end
  
  
end

