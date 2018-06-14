require "rails_helper"

describe "welcome/index.html.erb" do
  it "infers the controller path" do
    expect(controller.request.path_parameters[:controller]).to eq("welcome")
    expect(controller.controller_path).to eq("welcome")
  end

  it "renders partials" do
    @activities = Activity.user_scope().all.order(created_at: :desc).limit(20).paginate(:page => params[:page])
    @tasks = Task.user_scope().where("completed_at > ?", Date.today.beginning_of_day).limit(20).order(completed_at: :asc).paginate(:page => params[:page])
    @active_projects = Project.where(project_state_id: '1').all.paginate(:page => params[:page]).order('project_number DESC')
    @sales_cases = Project.where(project_state_id: '82').all.paginate(:page => params[:page]).order('project_number DESC')
    render
    expect(response).to render_template(partial: '_statistics_list')
  end
end
