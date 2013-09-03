require 'redmine'

Redmine::Plugin.register :enhanced_queries do
  name 'Enhanced Queries plugin'
  author 'Vladimir Pitin'
  author_url 'http://pitin.su'
  version '0.2'
  url 'http://rmplus.pro'
  
  settings  :partial => 'settings/enhanced_queries_settings',
            :default => { 'enable' => false, 
			                    'show_count' => false }  
end

Rails.application.config.to_prepare do
  IssuesHelper.send(:include, EnhancedQueriesIssuesHelperPatch)
  IssueQuery.send(:include, EnhancedQueriesQueryPatch)
  QueriesController.send(:include, EnhancedQueriesQueriesControllerPatch)
end

require 'hooks/views_enhanced_queries_hook'
