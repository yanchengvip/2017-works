class Mammon::InviteRecordsController < ApplicationController
  before_action :set_mammon_invite_record, only: [:show, :edit, :update, :destroy]

  # GET /mammon/invite_records
  # GET /mammon/invite_records.json
  def index
    @mammon_invite_records = Mammon::InviteRecord.all
  end

  # GET /mammon/invite_records/1
  # GET /mammon/invite_records/1.json
  def show
  end

  # GET /mammon/invite_records/new
  def new
    @mammon_invite_record = Mammon::InviteRecord.new
  end

  # GET /mammon/invite_records/1/edit
  def edit
  end

  # POST /mammon/invite_records
  # POST /mammon/invite_records.json
  def create
    @mammon_invite_record = Mammon::InviteRecord.new(mammon_invite_record_params)

    respond_to do |format|
      if @mammon_invite_record.save
        format.html { redirect_to @mammon_invite_record, notice: 'Invite record was successfully created.' }
        format.json { render :show, status: :created, location: @mammon_invite_record }
      else
        format.html { render :new }
        format.json { render json: @mammon_invite_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mammon/invite_records/1
  # PATCH/PUT /mammon/invite_records/1.json
  def update
    respond_to do |format|
      if @mammon_invite_record.update(mammon_invite_record_params)
        format.html { redirect_to @mammon_invite_record, notice: 'Invite record was successfully updated.' }
        format.json { render :show, status: :ok, location: @mammon_invite_record }
      else
        format.html { render :edit }
        format.json { render json: @mammon_invite_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mammon/invite_records/1
  # DELETE /mammon/invite_records/1.json
  def destroy
    @mammon_invite_record.destroy
    respond_to do |format|
      format.html { redirect_to mammon_invite_records_url, notice: 'Invite record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mammon_invite_record
      @mammon_invite_record = Mammon::InviteRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mammon_invite_record_params
      params.require(:mammon_invite_record).permit(:user_id)
    end
end
