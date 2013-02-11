class EntriesController < ApplicationController
  before_filter :find_user, :find_activity
  
  # GET /entries
  # GET /entries.json
  def index
    @entries = @activity.entries.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = @activity.entries.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = @activity.entries.new
    @entry.start_time = Time.now

    if @activity.tracked_by_goal?
      @entry.toward_goal = @activity.goals_tracking_this_activity.first.id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = @activity.entries.find(params[:id])
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = @activity.entries.new(params[:entry])

    respond_to do |format|
      if @entry.save
        format.html { redirect_to [@user, @activity, @entry], notice: 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = @activity.entries.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to [@user, @activity, @entry], notice: 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = @activity.entries.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to [@user, @activity]}
      format.json { head :no_content }
    end
  end
  
  private
  
  def find_activity
    if @user
      @activity = @user.activities.find(params[:activity_id])
    end
  end
  
  def setup_new
    @activities = @user.activities
  end
end
