# Sets up the user and admin information for us to login
role_user  = Role.create(name: 'user')
role_admin = Role.create(name: 'admin')
@user  = User.create(email: 'user@example.com', password: '123456')
@admin = User.create(email: 'admin@example.com', password: '123456')
@user.role  = role_user
@admin.role = role_admin
