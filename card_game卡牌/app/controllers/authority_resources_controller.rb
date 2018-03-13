class AuthorityResourcesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus3
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  def index
    @resources = AuthorityResource.active.page(params[:page].to_i).per(20)
  end

  def new
    @types = [{name: '全部资源', type: 'a'}, {name: '赛场管理', type: 'b'}, {name: '能量商城', type: 'c'}, {name: '兑奖阁管理', type: 'd'}, {name: '商品管理', type: 'e'}, {name: '营销管理', type: 'f'}, {name: '系统管理', type: 'j'},
              {name: '报表', type: 'h'}, {name: '统计', type: 'i'}
    ]
    @model_n = {
        #全部资源
        a: [{name: '全部资源', value: 'all'}],
        #赛场管理
        b: [
            {name: '赛场类型', value: 'game_type'},
            {name: '赛场列表', value: 'game'},
            {name: '赛场规则', value: 'game_rule'},
            {name: '自建赛场规则', value: 'self_game_rule'},
            {name: '卡包管理', value: 'card_bag'},
            {name: '竞赛竞争胜利记录', value: 'battle_winning_record'},
        ],
        #能量商城
        c: [{name: '能量商品', value: 'energy_product'},
            {name: '礼包分类', value: 'package_type'},
            {name: '礼包', value: 'package'},

        ],
        #兑奖阁管理
        d: [{name: '兑奖阁商品', value: 'mall_product'},
            {name: '兑奖阁兑换记录', value: 'mall_order'},
        ],

        #商品管理
        e: [{name: '商品管理', value: 'battle_product'},
            {name: '赛场商品分类', value: 'game_product_tag'},
            {name: '自建赛场商品分类', value: 'product_tag'},
            {name: '兑奖阁商品分类', value: 'mall_product_tag'},
        ],
        #营销管理
        f: [{name: '消息通知', value: 'msg_record'},
            {name: '赠送能量', value: 'card_user_own'},
            {name: '任务配置', value: 'task_setting'},
            {name: '宝箱管理', value: 'extreme_chest'},
        ],

        #系统管理
        j: [{name: '卡牌', value: 'card'},
            {name: '卡牌规则', value: 'card_rule'},
            {name: '管理员', value: 'admin'},
            {name: '角色', value: 'role'},
            {name: '权限资源管理', value: 'authority_resource'},
            {name: '饕鬄设置', value: 'glutton_setting'},
            {name: '版本列表', value: 'app_version'},
            {name: '赛点管理', value: 'web_setting'},
            {name: '文案管理', value: 'copy'},
            {name: '头像管理', value: 'headimg'},
        ],
        #报表
        h: [{name: '报表', value: 'download_csv'}
        ],
        #统计
        i: [{name: '统计', value: 'stati'}
        ],

    }
    @action_n = [
        {name: '全部权限', value: 'manage'},
        {name: '可读权限', value: 'read'},
        {name: '创建权限', value: 'create'},
        {name: '修改权限', value: 'update'},
        {name: '删除权限', value: 'destroy'},
        {name: '上下架/禁用权限', value: 'modify_status'}

    ]


  end


  def create
    ar = AuthorityResource.new(authority_resources_params)
    flash[:success] = "添加失败"
    if ar.save
      flash[:success] = "添加成功"
    end
    redirect_to '/authority_resources'
  end

  def destroy
    AuthorityResource.find(params[:id]).destroy()
    redirect_to '/authority_resources'
  end

  private

  def authority_resources_params
    params.permit(:name, :model_n, :action_n, :desc)
  end

end
