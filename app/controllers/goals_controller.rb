class GoalsController < ApplicationController
  before_filter :find_user
  
  # GET /goals
  # GET /goals.json
  def index
    @goals = @user.goals.non_project

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @goals }
    end
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
    @goal = @user.goals.find(params[:id])

    @tracked_activities = @goal.tracked_activities
    @untracked_activities = @goal.untracked_activities

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @goal }
    end
  end

  # GET /goals/new
  # GET /goals/new.json
  def new
    @goal = @user.goals.new

    if params[:project_id]
      @goal.project_id = params[:project_id]
      @goal.goal_type = "project-based"
    end
    
    @goal.started_on = Date.today

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @goal }
    end
  end

  # GET /goals/1/edit
  def edit
    @goal = @user.goals.find(params[:id])
    @activities = @user.activities

    @tracked_activities = @goal.tracked_activities
    @untracked_activities = @goal.untracked_activities
    
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal = @user.goals.new(params[:goal])
=begin    
    if params[:goal_amount].blank?
      @goal.errors[:base] << "Select score or duration for setting goal."
    elsif params[:goal_amount] == "score"
      if @goal.goal_amount_score.blank?
        @goal.errors[:goal_amount_score] << "should be set."
      end
      
      if !@goal.goal_amount_duration.blank?
        @goal.goal_amount_duration = nil
      end
    elsif params[:goal_amount] == "duration"
      if @goal.goal_amount_duration.blank?
        @goal.errors[:goal_amount_duration] << "should be set."
      end
      
      if !@goal.goal_amount_score.blank?
        @goal.goal_amount_score = nil
      end
    end
=end    
    if @goal.goal_type == 'recurring'
      case params[:goal_frequency]
      when "daily"
        @goal.goal_frequency = 1
        @goal.goal_frequency_unit = "day"
      when "weekly"
        @goal.goal_frequency = 1
        @goal.goal_frequency_unit = "week"
      when "bi-monthly"
        @goal.goal_frequency = 2
        @goal.goal_frequency_unit = "week"
      when "monthly"
        @goal.goal_frequency = 1
        @goal.goal_frequency_unit = "month"
      when "other"
        @goal.goal_frequency = params[:goal_frequency].to_i
        @goal.goal_frequency_unit = params[:frequency][:other_frequency_unit]
      end
    
    end
    
    if !@goal.errors.empty?
      render action: "new"
    else
      respond_to do |format|
        if @goal.save
          format.html { redirect_to [@user,@goal], notice: 'Goal was successfully created.' }
          format.json { render json: @goal, status: :created, location: @goal }
        else
          format.html { render action: "new" }
          format.json { render json: @goal.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /goals/1
  # PUT /goals/1.json
  def update
    @goal = @user.goals.find(params[:id])
    
    if params[:activity]
      if params[:untrack]
        @goal.untrack_activity(params[:activity][:id])
      else
        @goal.track_activity(params[:activity][:id])
      end
    end
    
    if params[:goal_amount] == "score"
      if @goal.goal_amount_score.blank?
        @goal.errors[:goal_amount_score] << "should be set."
      end
      
      if !@goal.goal_amount_duration.blank?
        @goal.goal_amount_duration = ""
      end
    end
      
    if params[:goal_amount] == "duration"
      if @goal.goal_amount_duration.blank?
        @goal.errors[:goal_amount_duration] << "should be set."
      end
      
      if !@goal.goal_amount_score.blank?
        @goal.goal_amount_score = ""
      end
    end
    
    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to [@user, @goal], notice: 'Goal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    @goal = @user.goals.find(params[:id])
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to user_goals_url(@user) }
      format.json { head :no_content }
    end
  end
end
