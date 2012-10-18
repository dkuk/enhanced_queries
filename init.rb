require 'redmine'

Redmine::Plugin.register :enhanced_queries do
  name 'Enhanced Queries plugin'
  author 'Pitin Vladimir Vladimirovich'
  author_url 'http://pitin.su'
  version '0.1'
  url 'http://pitin.su'
  
  settings  :partial => 'settings/enhanced_queries_settings',
            :default => {
            "enable" => "0", 
			"show_count" => "0"
            }  
end

Rails.application.config.to_prepare do
  IssuesHelper.send(:include, EnhancedQueriesIssuesHelperPatch)
  Query.send(:include, EnhancedQueriesQueryPatch)
  QueriesController.send(:include, EnhancedQueriesQueriesControllerPatch)
end

require 'hooks/views_sidebar_hook'
require 'hooks/views_enhanced_queries_hook'
