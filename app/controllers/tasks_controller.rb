class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /tasks
  # GET /tasks.json
  def index

    if params[:search]
      @tasks = Task.user_scope().search(params[:search]).order(completed_at: :asc).paginate(:page => params[:page])
      if @tasks.any?
        @tasks.order("created_at DESC")
      end
    else
     @tasks = Task.user_scope().where("completed_at > ?", Date.today.beginning_of_day).order(completed_at: :asc).paginate(:page => params[:page])
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task_types = TaskType.all
    @contacts = Contact.user_scope().all
    if params[:contact].present?
      @task.contact_id = Contact.find(params[:contact]).id
    end
  end

  # GET /tasks/1/edit
  def edit
    @task_types = TaskType.all
    @contacts = Contact.user_scope().all
  end

  # POST /tasks
  # POST /tasks.json
  def create
    task_params[:completed_at] = Time.parse(task_params[:completed_at])

    @task = Task.new(task_params)
    @task_types = TaskType.all
    @contacts = Contact.user_scope().all

    respond_to do |format|
      if @task.save
        if request.referrer.include? 'contacts'
          format.html { redirect_to request.referrer, notice: 'Task was successfully created.' }
          format.json { render :show, status: :created, location: @task }
        else
          format.html { redirect_to @task, notice: 'Task was successfully created.' }
          format.json { render :show, status: :created, location: @task }
        end
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    task_params[:completed_at] = Time.parse(task_params[:completed_at])

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :task_type_id, :user_id, :contact_id, :completed_at, :started_at, :end_date)
    end
end
