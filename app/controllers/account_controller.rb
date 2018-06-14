class AccountController < ApplicationController
	helper_method :sort_column, :sort_direction
	before_filter :authenticate_user!

	def sort_column
    ['name', 'type'].include?(params[:sort]) ? params[:sort] : "type"
  end

  def sort_direction
    params[:direction] == "desc" ? params[:direction] : "asc"
  end


	def show
		@activities = Activity.where({user_id:current_user.id}).limit(20).order(created_at: :desc).paginate(:page => params[:page])
		@tasks = Task.where({user_id:current_user.id}).where("completed_at > ?", Date.today.beginning_of_day).limit(20).order(completed_at: :asc).paginate(:page => params[:page])
		@projects = Project.all.paginate(:page => params[:page]).order('project_number DESC')
	end

	def edit
		@user = current_user
	end

	def activities
		@activities = Activity.where({user_id:current_user.id}).order(created_at: :desc).paginate(:page => params[:page])
	end

	def tasks
		@tasks = Task.where({user_id:current_user.id}).where("completed_at > ?", Date.today.beginning_of_day).order(completed_at: :asc).paginate(:page => params[:page])
	end

	def projects
		@projects = Project.where({user_id:current_user.id}).where.all.paginate(:page => params[:page]).order('project_number DESC')
	end
end
