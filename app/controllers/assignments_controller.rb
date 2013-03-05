class AssignmentsController < ApplicationController
  before_filter :find_user
  
  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = @user.assignments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignments }
    end
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @assignment = @user.assignments.find(params[:id])
    @components = @assignment.components

    @unapplied_tags = @user.tags.nin(id: @assignment.tag_ids)
    @applied_tags = @user.tags.in(id: @assignment.tag_ids)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment }
    end
  end

  # GET /assignments/new
  # GET /assignments/new.json
  def new
    @assignment = Assignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment }
    end
  end

  # GET /assignments/1/edit
  def edit
    @assignment = @user.assignments.find(params[:id])

    @unapplied_tags = @user.tags.nin(id: @assignment.tag_ids)
    @applied_tags = @user.tags.in(id: @assignment.tag_ids)
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = @user.assignments.create!(params[:assignment])
    
    @assignment.add_to_goal(params[:goal_id]) unless params[:goal_id].blank?

    respond_to do |format|
      if @assignment
        format.html { redirect_to [@user, @assignment], notice: 'Assignment was successfully created.' }
        format.json { render json: @assignment, status: :created, location: @assignment }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.json
  def update
    @assignment = @user.assignments.find(params[:id])
    
    if params[:tag]
      if params[:untag]
        @assignment.untag(params[:tag][:id])
      else  
        @assignment.tag(params[:tag][:id])
      end
    end
    
    @assignment.add_to_goal(params[:goal_id]) unless params[:goal_id].blank?
    
    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        format.html { redirect_to [@user, @assignment], notice: 'Assignment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment = @user.assignments.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to user_assignments_url(@user) }
      format.json { head :no_content }
    end
  end
  
end
