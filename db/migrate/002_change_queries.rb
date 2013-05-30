class ChangeQueries < ActiveRecord::Migration
  def self.up
    change_table :queries do |t|
      t.references :category
      t.integer :order
    end
  end

  def self.down
    remove_column :queries, :category_id
    remove_column :queries, :order
  end
end
