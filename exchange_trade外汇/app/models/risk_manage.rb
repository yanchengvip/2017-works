# ## Schema Information
#
# Table name: `risk_manages` # 风险管理
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id()`**         | `integer`          | `not null, primary key`
# **`risk_type(报警类型)`**    | `integer`          | `default(0)`
# **`percent(百分比)`**  | `decimal(16, 6)`   | `default(0.0)`
# **`level(等级)`**    | `integer`          | `default(0)`
# **`interval(报警间隔)`**   | `integer`          | `default(0)`
# **`number(发送次数)`**  | `integer`          | `default(1)`
# **`start_time(发送开始时间)`**       | `datetime`         |
# **`end_time(发送结束时间)`**     | `datetime`         |
# **`context(发送内容)`**  | `text(65535)`      |
# **`desc(备注)`**     | `text(65535)`      |
# **`dealer_id(券商表dealers表ID)`**             | `integer`          | `default(0)`
# **`dealer_type(关联券商类型dealer_type)`**                   | `integer`          | `default(0)`
# **`active(软删)`**   | `boolean`          | `default(TRUE)`
# **`name(名称)`**     | `string(255)`      |
#

class RiskManage < ApplicationRecord

end
