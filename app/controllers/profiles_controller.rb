class ProfilesController < ApplicationController
  before_filter :find_user
  
  # GET /profiles
  # GET /profiles.json
  def index
    redirect_to user_path(@user)
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = @user.profile

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = Profile.new
    @goal = @user.goals.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = @user.profile || Profile.new
  end

  # POST /profiles
  # POST /profiles.json
  def create
    
    @user.profile = Profile.new(params[:profile])
    if params[:goal_worth]
      @goal = @user.goals.create do |g|
        g.goal_type = "recurring"
        g.started_on = Date.today
        g.name = "What my time is worth"
        g.goal_amount_score = params[:goal_worth].to_i
      end
    else
      @goal = nil
    end
    
    respond_to do |format|
      
      if @user.profile && @goal
        
        format.html { redirect_to user_profiles_path, notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = @user.profiles.find(params[:id])
    @profile.update_attributes(params[:profile])
    if params["starting"] == "pending"
      @profile.started_on = nil
      @profile.target_completion_date = nil
    end

    respond_to do |format|
      if @profile.save
        format.html { redirect_to [@user, @profile], notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = @user.profile
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.json { head :no_content }
    end
    #redirect_to user_path(@user)
  end
end
