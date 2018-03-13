module ActAsActivable
  extend ActiveSupport::Concern

  included do |base|
    scope :active, -> { where(delete_flag: [false, nil]) }
  end

  module ClassMethods
    def all_active(reload = false)
      @all_active = nil if reload
      @all_active ||= active.all
    end
  end

  # instance methods
  def active?
    delete_flag == false
  end
end
