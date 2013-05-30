class CreateQueryCategories < ActiveRecord::Migration
  def self.up
    create_table :query_categories do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :query_categories
  end
end
