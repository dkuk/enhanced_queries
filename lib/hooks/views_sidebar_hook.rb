module RedmineEnhancedQueries
  module Hooks
    class ViewsSidebarHook < Redmine::Hook::ViewListener
      #render_on :view_issues_sidebar_issues_bottom, :partial => 'issues/mine_issues'
	  render_on :view_layouts_base_html_head, :partial => 'hooks/enhanced_queries/html_head'
    end
  end
end