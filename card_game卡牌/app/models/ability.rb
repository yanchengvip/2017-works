class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update_status, :shelf,:game_product_shelf,:self_game_product_shelf, :to => :modify_status
    alias_action :user_energy, :to => :read #能量管理
    alias_action :new_give, :create_give, :to => :create #能量管理
    alias_action :destroy_item,  :to => :destroy #免费宝箱
    alias_action :game_products,  :to => :read #平台赛场商品
    alias_action :self_game_products,  :to => :read #自建赛场商品
    alias_action :order_update,  :to => :update #战役订单修改
    alias_action :set_glutton,  :to => :read #饕鬄设置列表
    alias_action :save_gluttons,  :to => :update #饕鬄设置保存

    alias_action :balance,:energy,:glory,:score,:channel, :activy,:game,:recharge,:exchange,:to => :read #统计

    resources = user.authority_resources
    resources.each do |r|
      can r.action_n.to_sym, r.model_n.to_sym if r.action_n && r.model_n
    end
    #can :manage, :battle
    #can :read, :all
    #can :modify_status, :battle_product
    #can :create,:battle

    # :manage: 是指这个 controller 內所有的 action

    # :read : 指 :index 和 :show

    # :update: 指 :edit 和 :update

    # :destroy: 指 :destroy

    # :create: 指 :new 和 :create

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
