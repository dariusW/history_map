class UsersController < ApplicationController
  before_filter :pusher_api,      :only => [:auth]
  before_filter :signed_in_user,  :only => [:edit, :update]
  before_filter :correct_user,    :only => [:edit, :update]
  before_filter :admin_user,      :only => :destroy
  before_filter :async_is_signed, :only => :me
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def me
    @user = current_user
    @hash = {email: @user.email, id: @user.id, name: @user.name}
    Pusher["private-transmit"].trigger("my_data_#{params[:socket_id]}", @hash)
    render json: @hash
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      endflash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def index
    @users = User.paginate(:page => params[:page])
  end

  def auth
    if signed_in?
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end

  private

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, :notice => "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def pusher_api
    if(params[:channel_name].blank? || params[:socket_id].blank?)
      render :text => "Forbidden", :status => '403'
    end
  end
  
  def async_is_signed 
    unless signed_in?
      render :text => "Forbidden", :status => '403'
    end
  end

end
