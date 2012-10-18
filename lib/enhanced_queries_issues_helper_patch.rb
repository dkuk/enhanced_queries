# issue_patch.rb
require_dependency 'issue'
require_dependency 'issues_helper'


module EnhancedQueriesIssuesHelperPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

	# Same as typing in the class 
    base.class_eval do
		unloadable
		alias_method_chain :render_sidebar_queries, :enhance_queries
		alias_method_chain :sidebar_queries, :enhance_queries
		alias_method_chain :query_links, :enhance_queries
	end	
    

  end

  module ClassMethods   
    # Methods to add to the Issue class
	def get_total_of_issues(query_id, project)
      cond = "project_id IS NULL"
      cond << " OR project_id = #{project.id}" if project
      query = Query.find(query_id, :conditions => cond)	
	  query.issue_count.to_s
	  statement=query.statement	  
	  statement+=" AND project_id="+project.id.to_s if(project)
	  Issue.visible.count(:include => [:status, :project], :conditions =>statement).to_s
	  
	end	
	
	def render_queries_by_role(project)
		Issue.find_by_sql "
		SELECT 
		roles.name AS 'roles_name',
		roles.id AS 'roles_id',
		CONCAT(users.lastname, ' ', users.firstname) AS 'user_name',
		users.id AS 'user_id'
		FROM roles, member_roles, members, users
		WHERE builtin=0
		AND member_roles.role_id=roles.id
		AND member_roles.member_id=members.id
		AND users.id=members.user_id
		AND members.project_id="+project.id.to_s+"
		AND type!='Group'
		GROUP BY roles_name, roles_id, user_name, user_id
		ORDER BY roles_name "
	end	
	
	def get_total_issues_on_assigned_to_id(assigned_to_id, project)
		Issue.count :conditions => "issues.assigned_to_id="+assigned_to_id.to_s+" AND issues.project_id="+project.id.to_s+""	
	end
	
	def get_total_issues_on_assigned_to_role(assigned_to_role, project)
		query=Query.new(:name => "_", :filters => {'assigned_to_role' => {:operator => "=", :values => [assigned_to_role.to_s]}})
		statement=query.statement
		statement+=" AND project_id="+project.id.to_s if(project)
		Issue.count(:include => [:status, :project], :conditions => statement)
	end	
	
	def get_total_assigned_me_issues(project)
		query=Query.new(:name => "_", :filters => {'status_id' => {:operator => "o", :values => ["143535"]}, 'assigned_to_id' => {:operator => "=", :values => ["me"]}})
		statement=query.statement
		statement+=" AND project_id="+project.id.to_s if(project)
		Issue.count(:include => [:status, :project], :conditions => statement)
	end

	def get_total_i_am_watching(project)
		query=Query.new(:name => "_", :filters => {'status_id' => {:operator => "o", :values => ["143535"]}, 'watcher_id' => {:operator => "=", :values => ["me"]}})
		statement=query.statement
		statement+=" AND project_id="+project.id.to_s if(project)
		Issue.count(:include => [:status, :project], :conditions => statement)
	end	

	def get_total_i_created(project)
		query=Query.new(:name => "_", :filters => {'status_id' => {:operator => "o", :values => ["143535"]}, 'author_id' => {:operator => "=", :values => ["me"]}})
		statement=query.statement
		statement+=" AND project_id="+project.id.to_s if(project)
		Issue.count(:include => [:status, :project], :conditions => statement)
	end		
	
  end

  module InstanceMethods
    # Methods to add to specific issue objects
	
    def query_links_with_enhance_queries(title, queries)
		if(Setting.plugin_enhanced_queries['enable'] == 'true')
			# links to #index on issues/show
			url_params = controller_name == 'issues' ? {:controller => 'issues', :action => 'index', :project_id => @project} : params
		
			if queries.size
				queries_html=''.html_safe
				queries_html << content_tag('h3', h(title))
				cat_id=0

				queries.each { |query|
					if query.category_id!=cat_id	
						if(query.category_id)
							h4=(query.query_category.name.to_s!="")? content_tag('h4', h(query.query_category.name)) : ""
						else
							h4=""
						end
						if cat_id!=0
							queries_html << "</ul>#{h4}<ul>".html_safe
						else
							queries_html << "#{h4}<ul>".html_safe
						end
						cat_id=query.category_id
					end
					count=""			
					count=" <span class=\"count\">("+IssuesHelper.get_total_of_issues(query.id.to_s, @project)+")</span>" if Setting.plugin_enhanced_queries['show_count'] 
					queries_html << "<li>".html_safe << link_to(h(query.name), url_params.merge(:query_id => query)) << "#{count}</li>".html_safe
					}

				queries_html << '</ul>'.html_safe
			end
		else	
			query_links_without_enhance_queries(title, queries)
		end
    end		
	
    def render_sidebar_queries_with_enhance_queries
		if(Setting.plugin_enhanced_queries['enable'] == 'true')
			out = ''.html_safe
			
			queries = sidebar_queries.select {|q| !q.is_public?}
			out << query_links(l(:eq_label_my_queries), queries) if queries.any?
			cur_pr_queries = sidebar_queries.select {|q| (q.is_public? && q.project_id?)}
			out << query_links(l(:eq_label_current_project), cur_pr_queries) if cur_pr_queries.any?
			all_pr_queries = sidebar_queries.select {|q| (q.is_public? && !q.project_id?)}
			out << query_links(l(:eq_label_all_project), all_pr_queries) if all_pr_queries.any?			
			out	
		else
			render_sidebar_queries_without_enhance_queries
		end
    end	
	
    def sidebar_queries_with_enhance_queries
		if(Setting.plugin_enhanced_queries['enable'] == 'true')
=begin
			unless @sidebar_queries
			  # User can see public queries and his own queries
			  visible = ARCondition.new(["is_public = ? OR user_id = ?", true, (User.current.logged? ? User.current.id : 0)])
			  # Project specific queries and global queries
			  visible << (@project.nil? ? ["project_id IS NULL"] : ["project_id IS NULL OR project_id = ?", @project.id])
			  visible << (["query_categories.id=queries.category_id OR queries.category_id IS NULL"])
			  @sidebar_queries = Query.find(:all,
											:select => "queries.id, queries.name, is_public, project_id, category_id, query_categories.name",
											:include =>[:query_category],
											:order => "query_categories.name ASC, queries.order ASC, queries.name ASC",
											:conditions => visible.conditions)
			end
			@sidebar_queries
=end		
			@sidebar_queries ||= Query.visible.all(
				:order => "#{QueryCategory.table_name}.name ASC, #{Query.table_name}.order ASC, #{Query.table_name}.name ASC",
				# Project specific queries and global queries
				:include =>[:query_category],
				:conditions => (@project.nil? ? ["project_id IS NULL"] : ["project_id IS NULL OR project_id = ?", @project.id])
				)
			
		else
			sidebar_queries_without_enhance_queries
		end
    end		
	

  end
  
  
end

