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

# Ciudad
city = City.find_or_create_by!(name: "Medellin")

# Usuario por defecto
user_owner = User.find_or_create_by!(username: "admin") do |user|
  user.password = "password123"
  user.status = Status.find_by(name: "Activo")
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
    user.status = Status.find_by(name: "Activo")
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
    user.status = Status.find_by(name: "Activo")
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
    user.status = Status.find_by(name: "Activo")
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
    user.status = Status.find_by(name: "Activo")
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

Section.create!([
  { name: "ROLES", code: "roles", description: "Gestión de roles y sus permisos asociados." },
  { name: "PERMISOS", code: "permisos", description: "Control detallado de accesos por módulo." },
  { name: "MODULOS", code: "modulos", description: "Módulo de configuración de accesos por usuario." },
  { name: "USUARIO", code: "usuario", description: "Módulo de configuración de accesos por usuario." },
  { name: "TIPO TERCERO", code: "tipo_tercero", description: "Clasificación de terceros por tipo o naturaleza." },
  { name: "TIPO GASTO", code: "tipo_gasto", description: "Definición de categorías de gastos admitidos." },
  { name: "ESTADOS", code: "estados", description: "Manejo de estados para entidades del sistema." },
  { name: "TIEMPOS", code: "tiempos", description: "Configuración de tiempos y periodos operativos." },
  { name: "MOTIVOS", code: "motivos", description: "Listado de motivos para operaciones o movimientos." },
  { name: "RUTAS", code: "rutas", description: "Gestión de rutas logísticas o comerciales." },
  { name: "JERARQUIA", code: "jerarquia", description: "Estructura organizacional o jerárquica del sistema." },
  { name: "CLINTES", code: "clintes", description: "Módulo central de administración de clientes." },
  { name: "PRESTAMOS", code: "prestamos", description: "Gestión y seguimiento de préstamos otorgados." },
  { name: "ABONOS", code: "abonos", description: "Control de abonos y pagos realizados por clientes." },
  { name: "LIQUIDACIONES", code: "liquidaciones", description: "Control la liquidacion diaria." },
  { name: "REPORTES", code: "reportes", description: "Control de reportes." },
  { name: "GEOLOCALIZACION", code: "geolocalizacion", description: "Geoocalizacion de clientes." }

])

# create section 
Section.create!([
  { name: "PRESTAMOS MOVIL", code: "prestamo_movil", description: "Gestión de roles y sus permisos asociados." },
  { name: "ABONOS MOVIL", code: "abonos_movil", description: "Control detallado de accesos por módulo." },
  { name: "GASTOS MOVIL", code: "gastos_movil", description: "Módulo de configuración de accesos por usuario." },
  { name: "CLIENTES MOVIL", code: "clientes_movil", description: "Módulo de configuración de accesos por usuario." },

])

payment_terms_data = [
  [20, 60, "DIARIO", 1],
  [20, 60, "DIARIO", 1],
  [20, 30, "DIARIO", 1],
  [20, 24, "DIRIO", 1],
  [20, 120, "NECESITA AURORIZACION", 1],
  [20, 24, "DIARIO", 1],
  [20, 40, "SEMANAL", 7],
  [20, 40, "DIRARIO", 1],
  [20, 40, "NECESITA AUTORIZACION", 1],
  [20, 60, "DIARIO", 1],
  [0,   111111, "VENTA CONTADO", 1],
  [20, 30010, "MENSUAL", 0],
  [1,  31, "pago letras", 30],
  [20, 60, "SEMNAL", 7],
  [20, 45, "SEMANAL", 7],
  [20, 50, "DIARIO", 1],
  [20, 20, "DIARIO", 1]
]

puts "⏳ Creando términos de pago..."

payment_terms_data.each do |percentage, quota_days, payment_frequency, payment_days|
  monthly = payment_frequency.to_s.upcase.include?("MENSUAL") ? 0 : 1

  PaymentTerm.create!(
    percentage: percentage,
    quota_days: quota_days,
    payment_frequency: payment_frequency,
    payment_days: payment_days,
    monthly: monthly
  )
end

puts "✅ #{payment_terms_data.size} términos de pago creados con éxito."