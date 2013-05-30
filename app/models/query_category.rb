class QueryCategory < ActiveRecord::Base
  unloadable
  has_many :query, :class_name => 'Query', :foreign_key => 'category_id'
end
