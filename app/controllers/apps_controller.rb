class AppsController < ApplicationController
  def calendar
  end

  def chat
  end

  def email
  end

  def file_manager
  end

  def invoice_create
    render template: "apps/invoice/create"
  end

  def invoice_details
    render template: "apps/invoice/details"
  end

  def invoice_list
    render template: "apps/invoice/list"
  end
end
