class PagesController < ApplicationController
  layout :choose_layout

  def choose_layout
    action_name.in?(%w[maintenance coming_soon]) ? "base" : "vertical"
  end

  def coming_soon
  end

  def faq
  end

  def maintenance
  end

  def pricing
  end

  def pricing_2
  end

  def starter
  end

  def terms_conditions
  end

  def timeline
  end
end
