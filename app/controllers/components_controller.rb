class ComponentsController < ApplicationController
  before_filter :find_user, :find_activity
  
  # GET /components
  # GET /components.json
  def index
    @components = @activity.components.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @components }
    end
  end

  # GET /components/1
  # GET /components/1.json
  def show
    @component = @activity.components.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @component }
    end
  end

  # GET /components/new
  # GET /components/new.json
  def new
    @component = @activity.components.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @component }
    end
  end

  # GET /components/1/edit
  def edit
    @component = @activity.components.find(params[:id])
  end

  # POST /components
  # POST /components.json
  def create
    @component = @activity.components.new(params[:component])

    respond_to do |format|
      if @component.save
        format.html { redirect_to [@user, @activity], notice: 'Component was successfully created.' }
        format.json { render json: @component, status: :created, location: @component }
      else
        format.html { render action: "new" }
        format.json { render json: @component.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /components/1
  # PUT /components/1.json
  def update
    @component = @activity.components.find(params[:id])

    respond_to do |format|
      if @component.update_attributes(params[:component])
        format.html { redirect_to [@user, @activity], notice: 'Component was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @component.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /components/1
  # DELETE /components/1.json
  def destroy
    @component = @activity.components.find(params[:id])
    @component.destroy

    respond_to do |format|
      format.html { redirect_to user_activity_components_url(@user, @activity) }
      format.json { head :no_content }
    end
  end
  
  private
  
  def find_activity
    if @user
      @activity = @user.activities.find(params[:activity_id])
    end
  end
end
