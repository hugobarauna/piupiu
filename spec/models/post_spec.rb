require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  before(:each) do
    @valid_attributes = {
      :body => "value for body"
    }
  end

  it "should not be empty" do
    post = Post.new
    post.save.should_not be_true
  end

  it "should be shorter than 140 chars" do
    post = Post.new
    post.body = "a" * 150
    post.save.should be_false
  end
  
end
