class PackageItemsController < ApplicationController
  before_filter :set_package_item

  def destroy
    if @package_item.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  private
  def set_package_item
    @package_item = PackageItem.find(params[:id]) if params[:id]
  end

  # def package_items_params
  #   params.require(:package_item).permit(:prize_range, :lottery_times, :win_count, :prize_type, :package_id)
  # end
end
