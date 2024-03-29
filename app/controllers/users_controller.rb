class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :my_comments]  
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def show
    @user = User.find(params[:id])    
    @microposts = @user.microposts.paginate(page: params[:page])
    @comments = Comment.where(user_id: @user.id)
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # successful save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:sucess] = "User deleted"
    redirect_to users_url
  end

  def my_comments
    @user = current_user
    @posts = current_user.microposts
    @my_comments = []

    if @posts.any?
      @comments = @posts.first.comments
      @posts.each do |post|
        if post.comments.any?
          @comments.push(post.comments)
        end
      end

      @comments.each do |comment|
        @my_comments.push(comment)
      end
    end
  end

  def my_posts
    @user = current_user    
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def comments
    @user = current_user
    @comments = Comment.where(user_id: @user.id)
  end

  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                  :city, :phonenumber, :avatar, :card, :card_number)
    end

    # Confirms the correct user.
    def correct_user  
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end


