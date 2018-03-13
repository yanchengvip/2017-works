# README


# 客户端访问api时 header 中字段定义如下
* TOKEN  用户授权token，从登陆接口中获得
* DEVICE 设备信息
* DEALERTYPE 模拟盘 1 / wisdom 2

# 返回值说明
* 200  成功
* 406  登陆token过期
* 500  访问错误


#API说明
1. id 指表主键id 自增， created_at: 创建时间, updated_at: 更新时间
2. api 授权参数 TOKEN， 放到header中
3. 如果返回值为 {status: 406,  msg: "授权失效，请重新登陆"}， 说明token 失效或者没有传递该参数



#外汇项目后台及api
* 开发规范
* 2空格缩进对齐
* 所有函数注明参数类型 返回值 及作者



# Ruby version
*  ruby 2.4.1
*  rails 5.1.3
* 数据库软删除标志 active, default  true 未删除数据

# api文档生成方法
*  annotate  --force #生成model comment注释
*  yard #生成html 文档 ./doc

