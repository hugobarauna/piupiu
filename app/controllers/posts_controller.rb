class PostsController < ApplicationController
  before_filter :required_login, :except => :index

  def index
#    @posts = Post.find(:all, :order => "created_at DESC")
#    @posts = Post.paginate_by_board_id @board.id, :page => params[:page], :order => 'updated_at DESC'
    @posts = Post.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = @current_user.posts.build(params[:post])

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(user_home_path) }
        format.xml  { render :xml => @post, :status => :created }
        format.js
      else
        @posts = @current_user.posts
        format.html { render :template => "users/home" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
