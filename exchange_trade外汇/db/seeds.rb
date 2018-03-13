# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Dealer.create(name: '模拟盘', dealer_type: 1, status: 1, content: '模拟盘;', request_ip: '127.0.0.1', active: true)
Dealer.create(name: 'wisdom', dealer_type: 2, status: 1, content: 'wisdom;', request_ip: '127.0.0.1', active: true)
