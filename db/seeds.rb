# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

role_user = Role.create(name: 'user')
role_admin = Role.create(name: 'admin')
@user = User.create(email: 'user@example.com', password: '123456')
@admin = User.create(email: 'admin@example.com', password: '123456')

@user.role = role_user
@admin.role = role_admin
