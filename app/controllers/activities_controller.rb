class ActivitiesController < ApplicationController
  before_filter :find_user
  
  # GET /activities
  # GET /activities.json
  def index
    @activities = @user.activities

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activities }
    end
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    @activity = @user.activities.find(params[:id])
    @components = @activity.components

    @unapplied_tags = @user.tags.nin(id: @activity.tag_ids)
    @applied_tags = @user.tags.in(id: @activity.tag_ids)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity }
    end
  end

  # GET /activities/new
  # GET /activities/new.json
  def new
    @activity = Activity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity }
    end
  end

  # GET /activities/1/edit
  def edit
    @activity = @user.activities.find(params[:id])

    @unapplied_tags = @user.tags.nin(id: @activity.tag_ids)
    @applied_tags = @user.tags.in(id: @activity.tag_ids)
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = @user.activities.create!(params[:activity])
    
    @activity.add_to_goal(params[:goal_id]) unless params[:goal_id].blank?

    respond_to do |format|
      if @activity
        format.html { redirect_to [@user, @activity], notice: 'Activity was successfully created.' }
        format.json { render json: @activity, status: :created, location: @activity }
      else
        format.html { render action: "new" }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.json
  def update
    @activity = @user.activities.find(params[:id])
    
    if params[:tag]
      if params[:untag]
        @activity.untag(params[:tag][:id])
      else  
        @activity.tag(params[:tag][:id])
      end
    end
    
    @activity.add_to_goal(params[:goal_id]) unless params[:goal_id].blank?
    
    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to [@user, @activity], notice: 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity = @user.activities.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to user_activities_url(@user) }
      format.json { head :no_content }
    end
  end
  
end
