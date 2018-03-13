class Mammon::UserCodesController < ApplicationController
  before_action :set_mammon_user_code, only: [:show]


  def index
    @mammon_user_codes = Mammon::UserCode.all
  end

  def show

  end



  private

    def set_mammon_user_code
      @mammon_user_code = Mammon::UserCode.find(params[:id])
    end


    def mammon_user_code_params
      params.require(:mammon_user_code).permit(:user_id, :period_id, :codes, :count, :attack_user_id, :source_type)
    end
end
