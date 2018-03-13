class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include ActAsActivable
  #重写删除方法， 更改删除标记字段
  def destroy
    update_attribute(:active, nil)
    run_callbacks :destroy
    freeze
  end
end
