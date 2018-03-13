class Manage::AppVersionsController < ApplicationController
  before_action :set_manage_app_version, only: [:show, :edit, :update, :destroy]

  # GET /manage/app_versions
  # GET /manage/app_versions.json
  def index
    @manage_app_versions = Manage::AppVersion.all
  end

  # GET /manage/app_versions/1
  # GET /manage/app_versions/1.json
  def show
  end

  # GET /manage/app_versions/new
  def new
    @manage_app_version = Manage::AppVersion.new
  end

  # GET /manage/app_versions/1/edit
  def edit
  end

  # POST /manage/app_versions
  # POST /manage/app_versions.json
  def create
    @manage_app_version = Manage::AppVersion.new(manage_app_version_params)

    respond_to do |format|
      if @manage_app_version.save
        format.html { redirect_to @manage_app_version, notice: 'App version was successfully created.' }
        format.json { render :show, status: :created, location: @manage_app_version }
      else
        format.html { render :new }
        format.json { render json: @manage_app_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/app_versions/1
  # PATCH/PUT /manage/app_versions/1.json
  def update
    respond_to do |format|
      if @manage_app_version.update(manage_app_version_params)
        format.html { redirect_to @manage_app_version, notice: 'App version was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_app_version }
      else
        format.html { render :edit }
        format.json { render json: @manage_app_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/app_versions/1
  # DELETE /manage/app_versions/1.json
  def destroy
    @manage_app_version.destroy
    respond_to do |format|
      format.html { redirect_to manage_app_versions_url, notice: 'App version was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_app_version
      @manage_app_version = Manage::AppVersion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_app_version_params
      params.require(:manage_app_version).permit(:app_type, :app_version, :name, :mode, :version_code, :url, :active)
    end
end
