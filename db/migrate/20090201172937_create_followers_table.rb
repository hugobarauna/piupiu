class CreateFollowersTable < ActiveRecord::Migration
  def self.up
    create_table :followers, :id => false do |t|
      t.integer :follower_id, :null => false
      t.integer :followed_id, :null => false
      t.timestamps
    end
    
    execute 'ALTER TABLE followers ADD CONSTRAINT fk_follower_users FOREIGN KEY (follower_id) REFERENCES users(id)'
    execute 'ALTER TABLE followers ADD CONSTRAINT fk_followed_users FOREIGN KEY (followed_id) REFERENCES users(id)'
    
  end

  def self.down
    drop_table :followers
  end
end
