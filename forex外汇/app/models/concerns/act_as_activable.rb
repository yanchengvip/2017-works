module ActAsActivable
  extend ActiveSupport::Concern

  included do |base|
    scope :active, -> {where(active: true)}
  end



end
