class TagsController < ApplicationController
  before_filter :find_user
  
  # GET /tags
  # GET /tags.json
  def index
    @tags = @user.tags.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = @user.tags.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = @user.tags.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = @user.tags.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = @user.tags.new(params[:tag])

    respond_to do |format|
      if @tag.save
        format.html { redirect_to [@user, @tag], notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = @user.tags.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to [@user, @tag], notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = @user.tags.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to user_tags_url(@user) }
      format.json { head :no_content }
    end
  end
end
