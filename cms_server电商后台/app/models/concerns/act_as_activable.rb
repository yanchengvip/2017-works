module ActAsActivable
  extend ActiveSupport::Concern

  included do |base|
    scope :active, -> {where(active: true)}
  end

  module ClassMethods
    # 返回所有未删除数据
    def all_active(reload = false)
      @all_active = nil if reload
      @all_active ||= active.all
    end
  end

  # instance methods
  # 判断是否 为未删除数据
  def active?
    active == true
  end

  # 代替find方法，不存在或者已删除数据返回nil
  def acquire id
    begin
      model = find(id)
      mode.active? ? model : nil
    rescue Exception => e
      nil
    end
  end
end
