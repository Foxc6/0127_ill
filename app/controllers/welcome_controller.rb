class WelcomeController < ApplicationController

  ACTIVE_ID = ProjectState.find_by(name: 'Active').id
	SALES_CASE_ID = ProjectState.find_by(name: "Sales").id
  KILLED_ID = SaleCaseStatus.find_by(name: 'Killed').id

  def index
    setup = Preference.first
    if setup.present? && setup.is_setup
      #@activities = Activity.where({user_id:current_user.id})
      @activities = Activity.user_scope().all.order(created_at: :desc).limit(20).paginate(:page => params[:page])
      @tasks = Task.user_scope().where("completed_at > ?", Date.today.beginning_of_day).limit(20).order(completed_at: :asc).paginate(:page => params[:page])
      @active_project = Project.where(project_state_id: ACTIVE_ID)
      @active_projects = @active_project.all.paginate(:page => params[:page]).order('project_number DESC')
      @sales = Project.where(project_state_id: SALES_CASE_ID)
      @sales_cases = @sales.where.not(sale_case_status_id: KILLED_ID).paginate(:page => params[:page]).order('project_number DESC')


      @total_sales_records = @sales_cases.count

      year = Time.now.year
      @year_received_total = PaymentSchedule.by_year(year).sum(:total)

      @previous_sale_case = @active_project.where(was_sale_case: true)
      @previous_sale_cases = @previous_sale_case.all
      @progress_count = @previous_sale_cases.count
      @sales_target = @yearly_sales_goal - @year_received_total

      @today = DateTime.now
      @end_of_year = DateTime.now.end_of_year() - 1

      @days = @today.business_days_until(@end_of_year)
      @days_to_sell = remove_holidays()

      @latest_sale_case = @active_project.order("created_at").last
      if @latest_sale_case.present?
        @date_of_last_sale = @latest_sale_case.created_at
        @days_since_last_sale = (@today.to_date - @date_of_last_sale.to_date).to_i
      else
        @date_of_last_sale
        @days_since_last_sale
      end
      @active_sales_total = @active_project.sum(:total)
      @active_estimated_total = @active_project.sum(:estimated_total) - @active_project.sum(:total)
    else
      redirect_to preference_path
    end
  end

  def settings
  end


  def remove_holidays
    today = DateTime.now
    end_of_year = DateTime.now.end_of_year() - 1
    count = 0

    christmas_eve = '12/24'
    christmas_day = '12/25'

    h = {}
    (today.to_date..end_of_year).each {|x| h[h.count] = x.strftime("%m/%d")}

    if h.has_value?("11/24")
      count = count + 1
    end

    if h.has_value?("11/25")
      count = count + 1
    end

    if h.has_value?(christmas_eve)
      count = count + 1
    end

    if h.has_value?(christmas_day)
      count = count + 1
    end

    if h.has_value?("12/31")
      count = count + 1
    end

    if h.has_value?("1/1")
      count = count + 1
    end

    @days_to_sell = (today.business_days_until(end_of_year)) - (count)
  end

  def data
    @active_projects = Project.where(project_state_id: ACTIVE_ID).order("project_number ASC")
    render :json=>{
              :data => @active_projects.map{|project|{
                          :id => project.id,
                          :text => project.project_number,
                          :start_date => project.start_date.to_formatted_s(:db),
                          :duration => project.duration,
                          :progress => project.progress,
                          :sortorder => project.sortorder,
                          :parent => project.parent
                      }}
                    }
  end

  def help
  end


  def option_params
      params.require(:option).permit()
  end
end

