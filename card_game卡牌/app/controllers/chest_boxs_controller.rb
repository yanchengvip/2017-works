class ChestBoxsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus10
  before_action :set_chest_box
  skip_before_action :verify_authenticity_token, only: [:cash_box]

  def index
    @q = ChestBox.active.ransack(params[:q])
    @chest_boxs = @q.result.includes(:chest_records, :chest_box_prizes).page(params[:page]).per(15)
  end

  def show
    @prize_options = ChestPrize.active.select('id, name').map{|cp| [cp.name, cp.id]}
    @chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 1)
    @chest_box.check_type!
    @outputs = @chest_box.output
    @appoint_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 2)
    @given_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 3)
    @three_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 4)
    @app_product_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 5)
    @app_virtual_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 6)
    @h5_random_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 7)
    @h5_fix_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 8)
    @cash_fix_own_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 9)
    @cash_random_own_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 10)
  end

  def new
    @chest_box = ChestBox.new(prize_min: 1, prize_max: 2)
  end

  def create
    output = set_output params[:stage]
    prize_limit = set_prize_limit params[:prize_num_limit]
    @chest_box = ChestBox.new(chest_box_params.merge(output: output).merge(admin_id: current_user.id).merge(prize_limit: prize_limit))
    begin
      ActiveRecord::Base.transaction do
        if @chest_box.save!
          @chest_box.save_prizes!(params[:chest_box_prizes], params[:appoint_chest_box_prizes], params[:given_chest_box_prizes], params[:three_chest_box_prizes], params[:app_product_chest_box_prizes], params[:app_virtual_chest_box_prizes], params[:h5_random_chest_box_prizes], params[:h5_fix_chest_box_prizes], params[:cash_fix_prizes], params[:cash_random_prizes])
        end
        flash[:success] = '添加成功！'
        return redirect_to action: :index
      end
    rescue Exception => e
      flash[:danger] = '添加失败！' + e.to_s
      @chest_box
      return render action: :new
    end
  end

  def edit
    return redirect_to action: :index if @chest_box.status != 0
    @chest_box.check_type!
    @prize_options = ChestPrize.active.select('id, name').map{|cp| [cp.name, cp.id]}
    @chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 1)
    @outputs = @chest_box.output
    @appoint_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 2)
    @given_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 3)
    @three_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 4)
    @app_product_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 5)
    @app_virtual_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 6)
    @h5_random_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 7)
    @h5_fix_chest_box_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 8)
    @cash_fix_own_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 9)
    @cash_random_own_prizes = @chest_box.chest_box_prizes.includes(:chest_prize).where(prize_type: 10)
  end

  def update
    return redirect_to action: :index if @chest_box.status != 0
    output = set_output params[:stage]
    prize_limit = set_prize_limit params[:prize_num_limit]
    begin
      ActiveRecord::Base.transaction do
        if @chest_box.update_attributes!(chest_box_params.merge(output: output).merge(admin_id: current_user.id).merge(prize_limit: prize_limit))
          @chest_box.save_prizes!(params[:chest_box_prizes], params[:appoint_chest_box_prizes], params[:given_chest_box_prizes], params[:three_chest_box_prizes], params[:app_product_chest_box_prizes], params[:app_virtual_chest_box_prizes], params[:h5_random_chest_box_prizes], params[:h5_fix_chest_box_prizes], params[:cash_fix_prizes], params[:cash_random_prizes])
        end
        flash[:success] = '修改成功！'
        return redirect_to action: :index
      end
    rescue Exception => e
      flash[:danger] = '修改失败！' + e.to_s
      return redirect_to action: :edit, id: @chest_box.id
    end
  end

  def destroy
    flash[:notice] = '删除成功！'
    if @chest_box.status == 0
      @chest_box.destroy
    elsif @chest_box.chest_records.blank?
      @chest_box.close if @chest_box.status == 1
      @chest_box.destroy
    else
      flash[:notice] = '删除失败！'
    end
    redirect_to action: :index
  end

  def shelf
    begin
      if params[:shelf_status].to_i == 1
        @chest_box.with_lock do
          if @chest_box.status == 0
            @chest_box.update(status: 3)
            Thread.new {
              res = @chest_box.test_lottery
              Rails.logger.info("#{@chest_box.id}宝箱后台开启结果:#{res}")
              if res != true
                @chest_box.update(status: 0)
              end
            }
            return render json: {status: 200, msg: '操作成功'}
          else
            return render json: {status: 500, msg: "宝箱状态不可开启"}
          end
        end
      end

      ActiveRecord::Base.transaction do
        if params[:shelf_status].to_i == 2 && @chest_box.close
          return render json: {status: 200, msg: '操作成功'}
        else
          return render json: {status: 500, msg: "操作失败2"}
        end
      end
    rescue Exception => e
      return render json: {status: 500, msg: "操作失败1"}
    end
  end

  def get_prize_form
    case params[:prize_type].to_i
    when 2
      return render partial: 'appoint_form'
    when 3
      return render partial: 'given_form'
    when 4
      return render partial: 'three_form'
    when 5
      return render partial: 'app_product_form'
    when 6
      return render partial: 'app_virtual_form'
    when 7
      return render partial: 'h5_random_form'
    when 8
      return render partial: 'h5_fix_form'
    when 10
      return render partial: 'cash_random_form'
    else
      return render partial: 'prize_form'
    end
  end

  def get_prize
    chest_prize = ChestPrize.find params[:prize_id]
    return render json: {status: 200, msg: '', data: chest_prize}
  end

  def destroy_prize
    chest_box_prize = ChestBoxPrize.find_by(id: params[:box_prize_id].to_i)
    if chest_box_prize && chest_box_prize.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def copy
    res = @chest_box.copy!(current_user.id)
    if res[:status] == true
      return render json: {status: 200, msg: '复制成功'}
    end
    return render json: {status: 500, msg: res[:msg]}
  end

  def new_prize
  end

  def add_prize
    begin
      if @chest_box.add_prize!(params[:app_product_chest_box_prizes], params[:app_virtual_chest_box_prizes])
        flash[:success] = '添加成功！'
        return redirect_to action: :index
      end
    rescue Exception => e
      flash[:danger] = '添加失败！' + e.to_s
      return redirect_to action: :new_prize, id: @chest_box.id
    end
  end

  def cash_box
    if  request.method == 'POST'
      total_price = params["total_price"].to_f
      average_price = params["average_price"].to_f

      expect_count = (total_price / average_price).to_i

      total = params["cash_gains"].inject(0){|sum, x| sum += (x["ratio"].to_f * expect_count / 100).floor * x["num"].to_f }

      avg = total / params["cash_gains"].inject(0){|sum, x| sum += (x["ratio"].to_f * expect_count / 100).floor  }



      params["cash_gains"].each do |x|
        x[:count] = (x["ratio"].to_f * expect_count / 100).floor
      end

       # "cash_gains"=>[{"num"=>"12", "ratio"=>"10"}, {"num"=>"1", "ratio"=>"2"}]}
      render json: {avg: avg.round(2), data: params, total: total, status: 200}
    else
    end
  end

  def save_cash_box
  end

  def get_gain_form
    return render partial: 'gain_form'
  end


  private

  def chest_box_params
    params.require(:chest_box).permit!
  end

  def set_chest_box
    @chest_box = ChestBox.find(params[:id]) if params[:id]
  end

  def set_output stage
    output = []
    stage.each do |out|
      if out['out_prize'].to_i != 0 && out['out_worth'].to_i != 0
        output << [out['out_prize'].to_i, out['out_worth'].to_i]
      end
    end
    raise '产出奖品和价值至少要填写一个阶段' if output.blank?

    return output
  end

  def set_prize_limit limit_params
    prize_limit = {}
    limit_params && limit_params.each do |k, v|
      prize_limit.merge!({k.to_i => v.to_i})
    end
    return prize_limit
  end



end
