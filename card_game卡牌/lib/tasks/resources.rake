namespace :db do
  task resource_seed: :environment do
    generate_resources
  end


  def generate_resources
    ar = AuthorityResource.create!(name: '超级权限资源-所有的权限',model_n: 'all',action_n: 'manage')
    role = Role.where(name: '超级管理员').first
    if role.present?
      ar.role_authority_resources.create(role_id: role.id)
    end
  end
end