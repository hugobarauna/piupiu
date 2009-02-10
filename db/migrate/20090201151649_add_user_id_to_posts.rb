class AddUserIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :user_id, :integer, :null => false
    
    execute 'ALTER TABLE posts ADD CONSTRAINT fk_posts_users FOREIGN KEY (user_id) REFERENCES users(id)'
  end

  def self.down
    remove_column :posts, :user_id
  end
end
