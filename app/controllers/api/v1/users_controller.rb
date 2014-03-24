class Api::V1::UsersController < Api::V1::BaseController
  before_filter :set_user, only: [:show, :update, :destroy]
  
  def create
    # Before Rails 4:
    # user = User.new(params[:user])
    user = User.new(users_params)
    # The user model validation are run before save
    if user.save
      # We included the location in the header
      respond_with(user, :location => api_v1_user_path(user))
    else
      raise e  
    end
    rescue => e
      error = { :error => "Bad request"}
      respond_with(error, :status => 400, :location => api_v1_users_path)
  end
  
  def update
    # TODO implement set_user
    raise ActiveRecord::RecordNotFound unless user = User.find(params[:id])   
    unless !user
      user.update_attributes(users_params)
      respond_with(user)
    end
  rescue ActiveRecord::RecordNotFound
    error = { :error => "Not Found" }
    respond_with(error, :status => 404)
  end
  
  def show
    user = User.find_by_name(params[:name])
    user.password = nil if user
    if user
      respond_with(user)
    else
      # ActiveRecord::RecordNotFound is given by ActiveRecord
      raise ActiveRecord::RecordNotFound
    end
  rescue ActiveRecord::RecordNotFound
    error = { :error => "Not found" }
    respond_with(error, :status => 404)
  end
  
  def destroy
    # TODO implement set_user
    user = User.find(params[:id])
    if user
      user.destroy
      respond_with(user) 
    end
  end
  
  private
  
  def users_params
    params.require(:user).permit(:name, :password, :email, :bio)
  end
  
  def set_user
    
  end
end