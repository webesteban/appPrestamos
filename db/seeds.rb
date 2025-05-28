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
Status.find_or_create_by!(name: "Active")
Status.find_or_create_by!(name: "Blocked")

# Roles
admin_role = Role.find_or_create_by!(name: "Admin")
user_role  = Role.find_or_create_by!(name: "User")

# Ciudad
city = City.find_or_create_by!(name: "Caracas")

# Usuario por defecto
User.find_or_create_by!(username: "admin") do |user|
  user.password = "password123"
  user.status = Status.find_by(name: "Active")
  user.role = admin_role
  user.reason_block = nil
  user.email = "admin@example.com"
  user.phone = "04141234567"
  user.national_id = "V12345678"
  user.city = city
  user.address = "Calle Principal, Caracas"
  user.full_name = "Admin User"
end