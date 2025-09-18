# lib/tasks/loans.rake
namespace :loans do
  desc "Recalcula el estado de todos los préstamos según pagos y fechas"
  task update_statuses: :environment do
    puts "Recalculando estados de préstamos..."
    Loan.recalc_all_statuses!
    puts "Listo ✅"
  end
end