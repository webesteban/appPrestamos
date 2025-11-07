# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Payment.destroy_all
Loan.destroy_all
Client.destroy_all
CollectionUser.destroy_all
Expense.destroy_all
Collection.destroy_all
User.destroy_all
ExpenseType.destroy_all


ExpenseType.create!(name: 'Creado del admin', max_value: 9999999999)
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
cobrador_role = Role.find_or_create_by!(name: "COBRADORES", description: "COBRADORES")
Role.find_or_create_by!(name: "COBRADOR NO LIQUIDA", description: "COBRADOR NO LIQUIDA")
Role.find_or_create_by!(name: "SECRETARIA", description: "SECRETARIA")
Role.find_or_create_by!(name: "SECRETARIA NO LIQUIDA", description: "SECRETARIA NO LIQUIDA")
Role.find_or_create_by!(name: "SOLO ABONO", description: "SOLO ABONO")
Role.find_or_create_by!(name: "ENSAYO", description: "ENSAYO")

payment_terms_data = [
  [20, 30, "DIARIO 30 Días 20%", 1],
  [20, 60, "DIARIO 60 Días 20%", 1],
  [30, 30, "DIARIO 30 Días 30%", 1],
  [20, 24, "DIARIO 24 Días 20%", 1],
  [20, 120, "DIARIO 120 NECESITA AURORIZACION 20%", 1],
  [20, 40, "SEMANAL 40 Semanas 20%", 7],
  [20, 40, "DIARIO 40 Días 20%", 1],
  [20, 40, "DIARIO 40 Días NECESITA AUTORIZACION 20%", 1],
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
User.destroy_all
# Ciudad
city = City.find_or_create_by!(name: "Lima")
city = City.find_or_create_by!(name: "Bogota")
city = City.find_or_create_by!(name: "Colombia")
city = City.find_or_create_by!(name: "Peru")
city = City.find_or_create_by!(name: "Medellin")

# Usuario por defecto
user_owner = User.find_or_create_by!(username: "admin") do |user|
  user.password = "123"
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
    user.password = "123"
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

  cobrador1 = User.find_or_create_by!(username: "cobrador1") do |user|
    user.password = "123"
    user.status = Status.find_by(name: "Activo")
    user.role = cobrador_role
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

  collection1 = Collection.create!(name: cobrador1.username, payment_term: PaymentTerm.first) # ajustar según lógica
  CollectionUser.create!(user: cobrador1, collection: collection1)

  cobrador2 = User.find_or_create_by!(username: "cobrador2") do |user|
    user.password = "123"
    user.status = Status.find_by(name: "Activo")
    user.role = cobrador_role
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

  collection2 = Collection.create!(name: cobrador2.username, payment_term: PaymentTerm.first) # ajustar según lógica
  CollectionUser.create!(user: cobrador2, collection: collection2)

  cobrador3 = User.find_or_create_by!(username: "cobrador3") do |user|
    user.password = "123"
    user.status = Status.find_by(name: "Activo")
    user.role = cobrador_role
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

  collection3 = Collection.create!(name: cobrador3.username, payment_term: PaymentTerm.first) # ajustar según lógica
  CollectionUser.create!(user: cobrador3, collection: collection3)

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

Payment.destroy_all
Loan.destroy_all

Client.destroy_all

puts "✅ #{payment_terms_data.size} términos de pago creados con éxito."

collections = [collection1, collection2, collection3]

puts "📌 Creando cliente y préstamo de prueba..."

client = Client.create!(
  username: "123456789",
  identification: "123456789",
  identification_type: "CC",
  full_name: "Cliente Prueba",
  identification_issued_at: Date.new(2010, 1, 1),
  birth_date: Date.new(1990, 1, 1),
  sex: "M",
  address: "Dirección de prueba",
  mobile_phone: "3000000000",
  landline_phone: "6000000",
  billing_address: "Dirección de prueba",
  occupation: "Tester",
  workplace: "Empresa Prueba",
  income: 1000000,
  reference1_name: "Referencia Uno",
  reference1_identification: "11111111",
  reference1_address: "Calle 1",
  reference1_phone: "3000000001",
  reference2_name: "Referencia Dos",
  reference2_identification: "22222222",
  reference2_address: "Calle 2",
  reference2_phone: "3000000002",
  email: "clienteprueba@example.com",
  latitude: "6.2442",
  longitude: "-75.5812",
  collection_id: collection1.id
)

loan = Loan.create!(
  payment_term_id: PaymentTerm.first.id,
  client_id: client.id,
  installment_days: 30,
  amount: 260,
  details: "Préstamo de prueba de 30mil",
  insurance: false,
  insurance_amount: 0,
  created_at: Date.new(2025, 10, 20),
  latitude: "6.2442",
  longitude: "-75.5812"
)

puts "✅ Cliente de prueba creado con préstamo ID #{loan.id}"

puts "📌 Creando clientes..."
100.times do
  identification = Faker::Number.number(digits: 10)
  Client.create!(
    username: identification,
    identification: identification,
    identification_type: %w[CC TI CE PAS].sample,
    full_name: Faker::Name.name,
    identification_issued_at: Faker::Date.between(from: 20.years.ago, to: Date.today),
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 70),
    sex: %w[M F].sample,
    address: Faker::Address.full_address,
    mobile_phone: Faker::PhoneNumber.cell_phone_in_e164,
    landline_phone: Faker::PhoneNumber.phone_number,
    billing_address: Faker::Address.full_address,
    occupation: Faker::Job.title,
    workplace: Faker::Company.name,
    income: Faker::Number.number(digits: 6),
    reference1_name: Faker::Name.name,
    reference1_identification: Faker::Number.number(digits: 8),
    reference1_address: Faker::Address.full_address,
    reference1_phone: Faker::PhoneNumber.cell_phone_in_e164,
    reference2_name: Faker::Name.name,
    reference2_identification: Faker::Number.number(digits: 8),
    reference2_address: Faker::Address.full_address,
    reference2_phone: Faker::PhoneNumber.cell_phone_in_e164,
    email: Faker::Internet.unique.email,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    collection_id: collections.sample.id
  )
end


puts "📌 Creando préstamos para cada cliente..."
payment_term = PaymentTerm.first

Client.find_each do |client|
  # Decidimos el estado inicial del préstamo
  chosen_state = [:paid, :active, :overdue].sample

  # Si ya tiene un loan en mora, no le damos más
  if client.loans.overdue.exists?
    next
  end

  # Si ya tiene uno pagado, puede tener otro activo
  if client.loans.paid.exists?
    chosen_state = :active
  end

  # Si no tiene préstamos, seguimos con lo elegido random
  raw_amount = rand(100_000..7_000_000)
  normalized_amount = raw_amount / 1000 # guardamos en miles

  insurance_flag = [true, false].sample
  insurance_value = insurance_flag ? rand(100..500) : 0

  loan = Loan.create!(
    payment_term_id: payment_term.id,
    client_id: client.id,
    installment_days: 30,
    amount: normalized_amount,
    details: Faker::Lorem.sentence(word_count: 5),
    insurance: insurance_flag,
    insurance_amount: insurance_value,
    created_at: Faker::Date.between(from: 2.months.ago, to: Date.today),
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude
  )

  puts "   → Loan #{loan.id} creado para #{client.full_name} (estado simulado: #{chosen_state})"

  # --- Crear pagos según estado deseado ---
  user_id = client.collection.collection_users.first.user_id
  total_with_interest = loan.amount.to_f * 1.2
  base_amount = total_with_interest / loan.installment_days
  start_date = loan.created_at.to_date

  case chosen_state
  when :paid
    # Crea todos los pagos necesarios para cubrir el préstamo
    loan.installment_days.times do |i|
      payment_date = start_date + i.days
      break if payment_date > Date.today

      Payment.create!(
        client_id: client.id,
        loan_id: loan.id,
        user_id: user_id,
        amount: base_amount.round(2),
        latitude: loan.latitude,
        longitude: loan.longitude,
        paid_at: payment_date,
        details: "Pago automático (simulación estado pagado)"
      )
    end

  when :active
    # Pagos parciales, menos que el total
    num_payments = rand(1..(loan.installment_days / 2))
    num_payments.times do |i|
      payment_date = start_date + i.days
      break if payment_date > Date.today

      Payment.create!(
        client_id: client.id,
        loan_id: loan.id,
        user_id: user_id,
        amount: base_amount.round(2),
        latitude: loan.latitude,
        longitude: loan.longitude,
        paid_at: payment_date,
        details: "Pago automático (simulación estado activo)"
      )
    end

  when :overdue
    # Pagos incompletos y la fecha ya pasó del end_date
    num_payments = rand(1..(loan.installment_days / 3))
    num_payments.times do |i|
      payment_date = start_date + i.days
      break if payment_date > Date.today

      Payment.create!(
        client_id: client.id,
        loan_id: loan.id,
        user_id: user_id,
        amount: base_amount.round(2),
        latitude: loan.latitude,
        longitude: loan.longitude,
        paid_at: payment_date,
        details: "Pago automático (simulación estado moroso)"
      )
    end

    # Forzar end_date en el pasado para que caiga en mora
    loan.update!(end_date: Date.today - rand(1..15).days)
  end
end

puts "📌 Ejecutando recálculo de estados..."
Loan.recalc_all_statuses!

puts "✅ Préstamos y pagos creados con estados simulados"


puts "Recalculando estados de préstamos..."
Loan.recalc_all_statuses!
puts "OK ✅"
