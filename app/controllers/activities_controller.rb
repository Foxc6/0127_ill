class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /activities
  # GET /activities.json
  def index
    if params[:search]
      @activities = Activity.user_scope().search(params[:search]).order(created_at: :desc).paginate(:page => params[:page])
      if @activities.any?
        @activities.order("created_at DESC")
      end
    else
     @activities = Activity.user_scope().all.order(created_at: :desc).paginate(:page => params[:page])
    end
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    @activity_object = ActivityObject.where(id: @activity.activity_object_id).first
  end

  # GET /activities/new
  def new
    @activity = Activity.new
    @activity_types = ActivityType.user_scope().all
    @activity_objects = ActivityObject.user_scope().all
    @contacts = Contact.user_scope().all
    if params[:contact].present?
      @activity.contact_id = Contact.find(params[:contact]).id
    end
  end

  # GET /activities/1/edit
  def edit
    @activity_types = ActivityType.all
    @activity_objects = ActivityObject.all
    @contacts = Contact.user_scope().all
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)
    respond_to do |format|
      if @activity.save
        if request.referrer.include? 'contacts'
          format.html { redirect_to request.referrer, notice: 'Activity was successfully created.' }
          format.json { render :show, status: :created, location: @activity }
        else
          format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
          format.json { render :show, status: :created, location: @activity }
        end
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.user_scope().find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:name, :note, :activity_type_id, :activity_object_id, :user_id, :contact_id)
    end
end
