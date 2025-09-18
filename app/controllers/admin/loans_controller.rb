# app/controllers/admin/loans_controller.rb
class Admin::LoansController < ApplicationController
    def recalc
      Loan.recalc_all_statuses!
      head :ok
    end
  end