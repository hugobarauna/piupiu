class UsersController < ApplicationController
  before_filter :required_login, :only => :home
  
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /posts
  # POST /posts.xml
  def create
    @user = User.new(params[:user])

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'User was successfully created.'
      
      redirect_to(user_home_path)
    else
      render :action => "new"
    end
  end
  
  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end
  
  # GET /home
  def home
  end
  
end
