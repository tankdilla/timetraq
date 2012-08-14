class GoalsController < ApplicationController
  before_filter :find_user
  
  # GET /goals
  # GET /goals.json
  def index
    @goals = @user.goals.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @goals }
    end
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
    @goal = @user.goals.find(params[:id])
    @activities = @goal.activities

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @goal }
    end
  end

  # GET /goals/new
  # GET /goals/new.json
  def new
    @goal = @user.goals.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @goal }
    end
  end

  # GET /goals/1/edit
  def edit
    @goal = @user.goals.find(params[:id])
    @activities = @user.activities
    
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal = @user.goals.new(params[:goal])

    respond_to do |format|
      if @goal.save
        format.html { redirect_to [@user,@goal], notice: '@user.goals was successfully created.' }
        format.json { render json: @goal, status: :created, location: @goal }
      else
        format.html { render action: "new" }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /goals/1
  # PUT /goals/1.json
  def update
    @goal = @user.goals.find(params[:id])

    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to [@user, @goal], notice: '@user.goals was successfully updated.' }
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
