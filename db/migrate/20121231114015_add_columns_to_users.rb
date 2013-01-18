class AddColumnsToUsers < ActiveRecord::Migration
   def self.up
    add_column :users, :provider, :string
    add_column :users, :uid, :integer
  end
  def self.down
    remove_column :users, :provider, :string
    remove_column :users, :uid, :integer
  end
  end