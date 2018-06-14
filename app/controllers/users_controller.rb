class UsersController < ApplicationController
  before_action :set_project, only: [:show]

  respond_to :html

  def index
    @users = User.all.paginate(:page => params[:page])
  end

  def show
    respond_with(@user)
  end

  def update
    @user = current_user


    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to account_path, notice: 'Your acount was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:error] = @user.errors.full_messages
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email
        )
    end

  def set_project
    @user = User.find(params[:id])
  end
end
