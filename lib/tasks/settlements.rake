# frozen_string_literal: true
namespace :settlements do
    desc "Construye/actualiza liquidaciones del día para todas las rutas (collections). Usa DATE=YYYY-MM-DD opcional."
    task close_day: :environment do
      date = (ENV["DATE"] || Date.today.to_s).to_date
      puts "⏱  Generando liquidaciones para #{date}..."
  
      Collection.find_each do |collection|
        Settlements::BuildForDay.call(collection: collection, date: date)
        puts "  ✔ #{collection.id} - #{collection.name}"
      end
  
      puts "✅ Listo"
    end
  end
  