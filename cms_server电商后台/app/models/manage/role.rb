class Manage::Role < ApplicationRecord
  has_many :authority_role_relationships,->{where(active: true)}, dependent: :destroy
  has_many :authorities, ->{where(active: true)}, through: :authority_role_relationships
  attr_accessor :authority_ids, :choose_all, :choose_unall
  after_save :clear_cache
  def clear_cache
    Rails.cache.clear
  end

  def check_authority new_authority_ids
    new_authority_ids ||= []
    new_authority_ids = new_authority_ids.map(&:to_i)
    old_authority_ids = self.authority_role_relationships.active.pluck(:authority_id)
    add_authority_ids = new_authority_ids - old_authority_ids
    del_authority_ids = old_authority_ids - new_authority_ids
    ActiveRecord::Base.transaction do
      # del_authority_ids.each do |authority_id|
      #   self.authority_role_relationships.where(authority_id: authority_id).first.destroy
      # end
      self.authority_role_relationships.where(authority_id: del_authority_ids).destroy_all

      add_authority_ids.each do |authority_id|
        self.authority_role_relationships.create(authority_id: authority_id)
      end
    end
  end

end
