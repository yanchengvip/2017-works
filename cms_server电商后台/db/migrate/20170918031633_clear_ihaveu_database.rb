class ClearIhaveuDatabase < ActiveRecord::Migration[5.1]
  def up
    begin
      #drop_table :about_articles
    rescue Exception => e
      p e
    end
    begin
      #drop_table :about_jobs
    rescue Exception => e
      p e
    end
    begin
      #drop_table :about_links
    rescue Exception => e
      p e
    end
    begin
      #drop_table :about_people
    rescue Exception => e
      p e
    end
    begin
      #drop_table :about_users
    rescue Exception => e
      p e
    end
    begin
      #drop_table :admin_log
    rescue Exception => e
      p e
    end
    begin
      #drop_table :admin_roles
    rescue Exception => e
      p e
    end
    begin
      #drop_table :attr_value
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_activities  #活动表
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_ads        #广告
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_attributes  #属性
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_behaviors    #行为表
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_bidders      #属性 2011年最后一条
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_biddings     #出价记录 2011年最后一条
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_brand_images #品牌图片
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_brands #品牌
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_calls  #电话记录
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_cards  #优众卡
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_categories #分类
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_chances      #机会 表 12年
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_chats         # 对话 无记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_chats_messages  #对话消息 无记录
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_cities   #城市
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_cities_20101029  #无记录
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_clicks         #广告点击
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_collocations   #搭配 表 12年
    rescue Exception => e
      p e
    end
    begin
      #drop_table :auction_contacts  #收货地址
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_costumers # 顾客 表
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_countries  #国家
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_countries_20101029 #无数据
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_coupons #注册推广发券
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_customs_entries #报关记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_deliveries #无数据
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_events  # 券种
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_fanships  #品牌收藏
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_favorites #商品收藏
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_goods #物品 11年数据
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_guesses #猜价
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_guesses_chances #猜价机会
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_hits #浏览商品记录
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_images #商品图片
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_items #商品单件库存 后期删除
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_items_updatings
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_levels #用户等级
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_links #广告链接
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_locations #仓库地址
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_lotteries #抽奖
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_mailings #邮件发送 11年数据
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_mails    #邮件记录
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_mails_updatings
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_malls 商城
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_markets #专场 表 swf 配置数据
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_messages #erp同步记录 消息
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_multibuys #连拍
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_notifications #到货通知
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_operators # 座席 表 15年数据
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_packages #包装 12年数据
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_pages #首页配置 swf
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_pages_images #首页配置 swf 图片
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_pages_pages #子页面
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_pats #街拍 表 16年
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_pats_hotspots #街拍热点 表
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_payments #空表
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_pictures #邮件 图片
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_preferences # 偏好 表
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_product_operation_images #产品运营图片 表
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_products #商品
    rescue Exception => e
      p e
    end

    begin
      drop_table :auction_products_updatings #商品更改记录表
    rescue Exception => e
      p e
    end

    begin
      # drop_table :auction_promotions#推广 表
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_providers #供应商
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_provinces # 省
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_provinces_20101029 #空
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_queues #队列 表 13年
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_recommend_images #15年数据
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_recommends #推荐 表 swf配置数据
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_score_items # 微积分订单
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_shops #线下店
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_smss #短信
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_sorts #种类 表 12年
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_stickies #置顶 16年数据
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_stickies_images #置顶图片
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_synonyms #同义词 14年
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_tickets# 盒子11年
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_towns #区
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_towns_20101029 #区 空表
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_trades #订单
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_trades_updatings# 订单状态变更
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_transactions #用户card 余额变化记录
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_units #订单单件
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_usages #推广记录表
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_users #用户账户
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_users_updatings #用户积分状态 变更流水账
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_values#属性值 表
    rescue Exception => e
      p e
    end
    begin
      drop_table :auction_videos #视频
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_voucher_trades #优惠券订单
    rescue Exception => e
      p e
    end
    begin
      # drop_table :auction_vouchers #优惠券啊
    rescue Exception => e
      p e
    end
    begin
      drop_table :blog_notes#日志 13年
    rescue Exception => e
      p e
    end
    begin
      drop_table :blog_notes_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :blog_notes_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :blog_relations
    rescue Exception => e
      p e
    end
    begin
      drop_table :blog_relations_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :blog_users
    rescue Exception => e
      p e
    end

    begin
      drop_table :cashier_orders#收银 订单 空
    rescue Exception => e
      p e
    end
    begin
      drop_table :cashier_payments#收银 支付 空
    rescue Exception => e
      p e
    end

    begin
      drop_table :cat_sku_price #未找到使用记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :cat_sku_price_crstorage#未找到使用记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :cat_tax#未找到使用记录
    rescue Exception => e
      p e
    end

    begin
      drop_table :circle_photos#圈物 整个模块无用
    rescue Exception => e
      p e
    end
    begin
      drop_table :circle_photos_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :circle_photos_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :circle_relations
    rescue Exception => e
      p e
    end
    begin
      drop_table :circle_users
    rescue Exception => e
      p e
    end

    begin
      drop_table :content_articles #未找到使用记录 10年
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_categories
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_columns
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_editors
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_favorites
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_images
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_pages
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_sources
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_statics
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_tags
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_topic_articles
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_topic_images
    rescue Exception => e
      p e
    end
    begin
      drop_table :content_users
    rescue Exception => e
      p e
    end

    begin
      # drop_table :core_accounts#账户
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_accounts_updatings #变更手机号记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_affiliations #所属网络 表
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_affiliations_updatings # 更新记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_apps # 应用 10年
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_authorizations #授权
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_blockings # 空
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_blockings_updatings# 空
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_cities #城市
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_colleges #大学 10年
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_comments #评论 14
    rescue Exception => e
      p e
    end
    begin
      # drop_table :core_connections#设备授权 微信 微博等
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_contacts #14年
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_devices #登陆设备
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_feeds #新鲜事
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_feeds_readings #
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_friendships#主站 好友关系
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_friendships_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_help_articles
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_help_categories
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_hidings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_hidings_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_idfas
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_inbox
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_infos
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_infos_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_invitations
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_invitations_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_ips
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_keywords
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_keywords_0901
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_likes
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_likes_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_links
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_lists
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_lists_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_lists_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_logins
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_messages
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_networks
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_notifications
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_outlook_contacts
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_phones
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_records
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_registrations
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_replies
    rescue Exception => e
      p e
    end
    begin
      # drop_table :core_reports # 反馈
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_requests
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_scores
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_settings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_settings_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_shares
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_shares_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_similarities
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_stats
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_status
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_status_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_streams
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_trades
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_transactions
    rescue Exception => e
      p e
    end
    begin
      # drop_table :core_users
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_users_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_users_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :core_visits
    rescue Exception => e
      p e
    end


    begin
      drop_table :data_bible_articles
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_bible_articles_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_bible_audios
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_bible_categories
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_bible_categories_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_bible_images
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_bible_patterns
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_bible_videos
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_common_countries
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_common_currencies
    rescue Exception => e
      p e
    end
    begin
      # drop_table :data_common_files #文件配置
    rescue Exception => e
      p e
    end

    begin
      drop_table :data_editors
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_articles
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_articles_brands
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_articles_people
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_articles_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_audios
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_categories
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_images
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_patterns
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_people
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_news_videos
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_product_articles
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_product_articles_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_product_brands
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_product_categories
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_product_crowds
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_product_images
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_product_occasions
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_roles
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_users
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_audios
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_images
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_magazines
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_magazines_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_pages
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_pages_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_popups
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_texts
    rescue Exception => e
      p e
    end
    begin
      drop_table :data_uzine_videos
    rescue Exception => e
      p e
    end

    begin
      drop_table :delayed_jobs #未使用
    rescue Exception => e
      p e
    end
    begin
      drop_table :delivery_detail
    rescue Exception => e
      p e
    end
    begin
      drop_table :develop_document_editors
    rescue Exception => e
      p e
    end
    begin
      drop_table :develop_document_pages
    rescue Exception => e
      p e
    end
    begin
      drop_table :develop_document_roles
    rescue Exception => e
      p e
    end
    begin
      drop_table :develop_users
    rescue Exception => e
      p e
    end

    begin
      drop_table :dxorder_time
    rescue Exception => e
      p e
    end

    begin
      drop_table :erp_ac
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_admin
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_analysemobile
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_analyseout
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_attrs
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_barcode
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_brand
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_bsgoods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_bsgoods_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_bsorder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_bsphoto
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cat
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cat_copy
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cf_cjorder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cforder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_city_rate
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cjgoods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cjgoods_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cjorder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cjorder_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cjt
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cjt_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_cjt_goods_temp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_color
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_counttype
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crdaily
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crgoods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crgoods_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crorder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crorder_bind_cjorder_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crstorage
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crstorage_bak810
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crstorage_log
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_crstorage_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_damagetype
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_delivery
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_department
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_dxorder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_dxorder_logs
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_excforder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_exorders
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_exorders_good
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_fee
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_goods_back
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_goods_img
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_goods_logs
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_goodsfill
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_intype
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_lock
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_menu
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_message
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_online_warning_email
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_order_price_analyse
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_orders_statistics
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_otherin
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_otherout
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_otherout_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_otherout_goods_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_outtype
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_recsheet
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_roles
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_saleback
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_saleback_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_saleout
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_saleout_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_size
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_sizes
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_storage
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_storage_gather
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_storder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_storder_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_storder_goods_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_supplier
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_supplier_change_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_supplier_change_order
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_tariff
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_tax
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_tf_cjorder
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_transfer
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_transfer_goods
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_transfer_goods_tmp
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_unit
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_warning
    rescue Exception => e
      p e
    end
    begin
      drop_table :erp_warning_sku
    rescue Exception => e
      p e
    end


    begin
      drop_table :goods_log
    rescue Exception => e
      p e
    end
    begin
      drop_table :groupon_coupons#团购
    rescue Exception => e
      p e
    end
    begin
      drop_table :groupon_coupons_updatings#团购
    rescue Exception => e
      p e
    end
    begin
      drop_table :groupon_group_trades#团购
    rescue Exception => e
      p e
    end
    begin
      drop_table :groupon_groups#团购
    rescue Exception => e
      p e
    end

    begin
      drop_table :import_goods_log#导入日志
    rescue Exception => e
      p e
    end

    begin
      # drop_table :manage_editors#编辑
    rescue Exception => e
      p e
    end
    begin
      drop_table :manage_editors_old#12年数据
    rescue Exception => e
      p e
    end
    begin
      # drop_table :manage_grants #授权
    rescue Exception => e
      p e
    end
    begin
      drop_table :manage_grants_old #13年数据
    rescue Exception => e
      p e
    end
    begin
      drop_table :manage_logs # 管理端访问日志
    rescue Exception => e
      p e
    end
    begin
      # drop_table :manage_roles #角色
    rescue Exception => e
      p e
    end
    begin
      drop_table :manage_roles_old #13年数据
    rescue Exception => e
      p e
    end
    begin
      # drop_table :manage_users #后台用户
    rescue Exception => e
      p e
    end

    begin
      drop_table :office_finance_currencies #办公相关
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_finance_exchange_rates
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_human_companies
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_human_departments
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_human_employees
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_purchase_applications
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_purchase_demands
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_purchase_providers
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_purchase_quotations
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_purchase_quotations_demands
    rescue Exception => e
      p e
    end
    begin
      drop_table :office_purchase_reviews
    rescue Exception => e
      p e
    end

    begin
      drop_table :pay_behaviors
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_cards
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_cashiers
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_checkouts
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_cities
    rescue Exception => e
      p e
    end
    begin
      # drop_table :pay_cmb_signs #招行一网通签约表
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_counters
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_deals
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_exchanges
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_industries
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_levels
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_malls
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_manuals
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_merchants
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_orders
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_rates
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_refundments
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_stores
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_tickets
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_transactions
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_transfers
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_users
    rescue Exception => e
      p e
    end
    begin
      drop_table :pay_users_updatings
    rescue Exception => e
      p e
    end

    begin
      drop_table :photo_albums#相册 相册
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_albums_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_albums_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_photos
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_photos_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_photos_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_relations
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_relations_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :photo_users
    rescue Exception => e
      p e
    end

    begin
      drop_table :productivity_design_categories#12年
    rescue Exception => e
      p e
    end
    begin
      drop_table :productivity_design_images
    rescue Exception => e
      p e
    end
    begin
      drop_table :productivity_design_pages
    rescue Exception => e
      p e
    end

    begin
      # drop_table :retail_carts #购物车
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_commissions
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_games
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_guides
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_mall_promotions
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_shops
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_topics
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_trophies
    rescue Exception => e
      p e
    end
    begin
      drop_table :retail_users
    rescue Exception => e
      p e
    end

    begin
      drop_table :ruby_message #11年
    rescue Exception => e
      p e
    end
    begin
      # drop_table :schema_migrations #数据库版本管理
    rescue Exception => e
      p e
    end

    begin
      drop_table :search_brand_mappings#搜索模块
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_brands
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_categories
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_category_mappings
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_editors
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_malls
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_products
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_products_updatings
    rescue Exception => e
      p e
    end
    begin
      drop_table :search_users
    rescue Exception => e
      p e
    end

    begin
      drop_table :sessions #10年
    rescue Exception => e
      p e
    end

    begin
      drop_table :share_audios#空
    rescue Exception => e
      p e
    end
    begin
      drop_table :share_files#空
    rescue Exception => e
      p e
    end
    begin
      drop_table :share_images#空
    rescue Exception => e
      p e
    end
    begin
      drop_table :share_pages#空
    rescue Exception => e
      p e
    end
    begin
      drop_table :share_videos#空
    rescue Exception => e
      p e
    end

    begin
      drop_table :simple_captcha_data#验证码 新版存储于redis
    rescue Exception => e
      p e
    end
    begin
      drop_table :size_category#未使用
    rescue Exception => e
      p e
    end
    begin
      drop_table :size_sizes#未使用
    rescue Exception => e
      p e
    end

    begin
      drop_table :social_users#空
    rescue Exception => e
      p e
    end

    begin
      drop_table :storage_detail#未使用
    rescue Exception => e
      p e
    end
    begin
      drop_table :supplier_contact#未使用
    rescue Exception => e
      p e
    end
    begin
      drop_table :sync_log#未使用
    rescue Exception => e
      p e
    end

    begin
      drop_table :talk_inboxes#优信模块 收件箱11
    rescue Exception => e
      p e
    end
    begin
      drop_table :talk_messages
    rescue Exception => e
      p e
    end
    begin
      drop_table :talk_notifications
    rescue Exception => e
      p e
    end
    begin
      drop_table :talk_replies
    rescue Exception => e
      p e
    end
    begin
      drop_table :talk_requests
    rescue Exception => e
      p e
    end
    begin
      drop_table :talk_users
    rescue Exception => e
      p e
    end

    begin
      drop_table :trade_log#未使用
    rescue Exception => e
      p e
    end

    begin
      drop_table :vote_answers#未使用10年
    rescue Exception => e
      p e
    end
    begin
      drop_table :vote_users
    rescue Exception => e
      p e
    end
    begin
      drop_table :vote_votes
    rescue Exception => e
      p e
    end
    begin
      drop_table :vote_votes_readings
    rescue Exception => e
      p e
    end
    begin
      drop_table :vote_votes_updatings
    rescue Exception => e
      p e
    end


    begin
      drop_table :wechat_invitations#16年 未找到使用记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :wechat_redpacks#16年 未找到使用记录
    rescue Exception => e
      p e
    end
    begin
      drop_table :wechat_scans#扫码记录 未找到使用记录
    rescue Exception => e
      p e
    end

    begin
      # drop_table :wechat_shares#分享数据
    rescue Exception => e
      p e
    end

  end


  def down
  end
end
