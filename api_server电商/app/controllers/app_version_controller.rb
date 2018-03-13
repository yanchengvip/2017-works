class AppVersionController < ApplicationController
  skip_before_action :login_filter
  def current
    render json: {status: 200, data: AppVersion.current, msg: ""}
  end

  def old
    render json: {:configs=>[{:id=>"1", :name=>"优众", :version=>"3.6.5", :desc=>"当前有新版本可供更新。更新内容如下：\n 1.修复部分用户闪退\n2.提升性能！ \n是否立即更新？", :mode=>"force", :versionCode=>"", :url=>"https://itunes.apple.com/us/app/you-zhong/id506299184?mt=8&uo=4"}, {:id=>"2", :name=>"优众", :version=>"3.1.2", :desc=>"当前有新版本可供更新。更新内容如下：\n 1.提升了性能\n2.修复了部分bug！\n是否立即更新？", :mode=>"force", :versionCode=>"17", :url=>"http://m.ihaveu.com/cdn/android/ihaveu_latest.apk"}]}
  end
end
