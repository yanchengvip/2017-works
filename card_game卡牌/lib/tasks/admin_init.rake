namespace :db  do
  task admin_init:  :environment do
    generate_admin
  end
end

def generate_admin
  Admin.create!(nickname: 'admin', phone: '13312345678', encrypted_password: '123456', name: 'super_admin', email: 'test@qq.com')

  Role.create!(name: '超级管理员', en_name: 'cjgly',remark: '超级管理员拥有所有权限')
  Role.create!(name: '运营人员', en_name: 'yyry',remark: '运营人员')

  admin = Admin.first
  admin.roles << Role.first
end
