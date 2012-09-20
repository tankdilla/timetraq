class ProjectsController < ApplicationController
  before_filter :find_user
  
  # GET /projects
  # GET /projects.json
  def index
    @projects = @user.projects.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = @user.projects.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = @user.projects.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = @user.projects.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = @user.projects.new(params[:project])
    
    if params["starting"] == "pending"
      @project.started_on = nil
    end

    respond_to do |format|
      if @project.save
        format.html { redirect_to [@user, @project], notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = @user.projects.find(params[:id])
    @project.update_attributes(params[:project])
    if params["starting"] == "pending"
      @project.started_on = nil
      @project.target_completion_date = nil
    end

    respond_to do |format|
      if @project.save
        format.html { redirect_to [@user, @project], notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = @user.projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to user_projects_url(@user) }
      format.json { head :no_content }
    end
  end
end
