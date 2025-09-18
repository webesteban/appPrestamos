# frozen_string_literal: true
module Settlements
    class FetchOrCreate
      def self.call(collection_id:, date:)
        new(collection_id, date).call
      end
  
      def initialize(collection_id, date)
        @collection_id = collection_id
        @date = date.to_date
      end
  
      def call
        # Busca si ya existe liquidación en ese día
        existing = Settlement.find_by(collection_id: @collection_id, settlement_date: @date)
        return existing if existing.present?
  
        # Busca liquidación anterior
        prev = Settlement.where(collection_id: @collection_id)
                         .where("settlement_date < ?", @date)
                         .order(settlement_date: :desc)
                         .first
  
        base_start = prev&.base_carryover || 0
  
        # Crea la plantilla mínima
        Settlement.create!(
          collection_id: @collection_id,
          settlement_date: @date,
          previous_settlement_id: prev&.id,
          base_start: base_start,
          payments_total: 0,
          payments_count: 0,
          loans_total: 0,
          loans_count: 0,
          expenses_total: 0,
          other_expenses_total: 0,
          other_expenses_note: nil,
          delivered_cash: 0,
          expected_cash: base_start,  # Al inicio lo esperado es igual a la base
          difference: 0,
          base_carryover: base_start,
          snapshot: {},
          status: "draft"
        )
      end
    end
  end
  