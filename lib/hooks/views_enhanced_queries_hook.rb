module RedmineEnhancedQueries
  module Hooks
    class ViewsEnhancedQueriesHook < Redmine::Hook::ViewListener
      render_on :view_issues_sidebar_queries_bottom, :partial => 'issues/queries_by_role'
    end
  end
end