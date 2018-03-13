class InitAdminRole < ActiveRecord::Migration[5.0]
  def change
    ar = AuthorityResource.active.where(name: '超级权限资源-所有的权限', model_n: 'all', action_n: 'manage').first
    if ar.blank?
      ar = AuthorityResource.create!(name: '超级权限资源-所有的权限',model_n: 'all',action_n: 'manage')
    end
    role = Role.active.where(name: '超级管理员').first
    if role.present?
      ar.role_authority_resources.create(role_id: role.id)
    end
  end
end
