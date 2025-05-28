# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Estados posibles
Status.find_or_create_by!(name: "Activo")
Status.find_or_create_by!(name: "Blocked")

# Roles
admin_role = Role.find_or_create_by!(name: "Administrador", description: "Administrador")
Role.find_or_create_by!(name: "DUEÑO", description: "DUEÑO")
Role.find_or_create_by!(name: "DUEÑO NO LIQUIDA", description: "DUEÑO NO LIQUIDA")
Role.find_or_create_by!(name: "SOCIO", description: "SOCIO")
Role.find_or_create_by!(name: "SOCIO COBRADOR NO LIQUIDA", description: "SOCIO NO LIQUIDA")
Role.find_or_create_by!(name: "AUDITOR-ROTADOR NO LIQUIDAR", description: "ROTADOR SIN LIQUIDAR")
Role.find_or_create_by!(name: "AUDITOR-ROTADOR", description: "LIQUIDA")
Role.find_or_create_by!(name: "COBRADORES", description: "COBRADORES")
Role.find_or_create_by!(name: "COBRADOR NO LIQUIDA", description: "COBRADOR NO LIQUIDA")
Role.find_or_create_by!(name: "SECRETARIA", description: "SECRETARIA")
Role.find_or_create_by!(name: "SECRETARIA NO LIQUIDA", description: "SECRETARIA NO LIQUIDA")
Role.find_or_create_by!(name: "SOLO ABONO", description: "SOLO ABONO")
Role.find_or_create_by!(name: "ENSAYO", description: "ENSAYO")

user_role  = Role.find_or_create_by!(name: "User")

# Ciudad
city = City.find_or_create_by!(name: "Medellin")

# Usuario por defecto
user_owner = User.find_or_create_by!(username: "admin") do |user|
  user.password = "password123"
  user.status = Status.find_by(name: "Active")
  user.role = admin_role
  user.reason_block = nil
  user.email = "admin@example.com"
  user.phone = "04141234567"
  user.national_id = "V12345678"
  user.city = city
  user.address = "Calle Principal, Medellin"
  user.full_name = "Admin User"
  user.hierarchy_level = 1
end


user_socio = User.find_or_create_by!(username: "socio") do |user|
    user.password = "password123"
    user.status = Status.find_by(name: "Active")
    user.role = admin_role
    user.reason_block = nil
    user.email = "socio@example.com"
    user.phone = "04141234567"
    user.national_id = "V12345678"
    user.city = city
    user.address = "Calle Principal, Medellin"
    user.full_name = "Socio User"
    user.parent_id = user_owner.id
    user.hierarchy_level = 2
  end

  User.find_or_create_by!(username: "Cobrador1") do |user|
    user.password = "password123"
    user.status = Status.find_by(name: "Active")
    user.role = admin_role
    user.reason_block = nil
    user.email = "socio@example.com"
    user.phone = "04141234567"
    user.national_id = "V12345678"
    user.city = city
    user.address = "Calle Principal, Medellin"
    user.full_name = "Cobrador 1 User"
    user.parent_id = user_socio.id
    user.hierarchy_level = 3
  end

  User.find_or_create_by!(username: "Cobrador2") do |user|
    user.password = "password123"
    user.status = Status.find_by(name: "Active")
    user.role = admin_role
    user.reason_block = nil
    user.email = "socio@example.com"
    user.phone = "04141234567"
    user.national_id = "V12345678"
    user.city = city
    user.address = "Calle Principal, Medellin"
    user.full_name = "Cobrador 1 User"
    user.parent_id = user_socio.id
    user.hierarchy_level = 3
  end

  User.find_or_create_by!(username: "Cobrador3") do |user|
    user.password = "password123"
    user.status = Status.find_by(name: "Active")
    user.role = admin_role
    user.reason_block = nil
    user.email = "socio@example.com"
    user.phone = "04141234567"
    user.national_id = "V12345678"
    user.city = city
    user.address = "Calle Principal, Medellin"
    user.full_name = "Cobrador 3 User"
    user.parent_id = user_socio.id
    user.hierarchy_level = 3
  end