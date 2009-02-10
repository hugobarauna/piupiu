class UserSessionsController < ApplicationController
  before_filter :required_login, :only => :destroy
  
  # - GET /account/login
  #
  def new
    @user = User.new
  end

  # - POST /account/session
  #
  def create
    if @user = User.find_and_authenticate(params[:user]) 
      flash[:notice] = 'Login successfull'
      session[:user_id] = @user.id

      redirect_to(session[:return_to] || user_home_path)
      session[:return_to] = nil
    else
      @user = User.new(params[:user])

      if params[:user]
        if params[:user][:email].blank?
          flash[:error] = "Email can't be blank"
        elsif params[:user][:password].blank?
          flash[:error] = "Password can't be blank"
        else
          flash[:error] = "Email and password does not match"
        end
      end

      render :action => 'new'
    end
    
  end

  # DELETE /account/session
  def destroy
    flash[:notice] = "Logout done. Come back later! =)" if session[:user_id]
    session[:user_id] = nil

    redirect_to root_path
  end
  
end
