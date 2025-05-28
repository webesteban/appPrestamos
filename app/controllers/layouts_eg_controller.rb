class LayoutsEgController < ApplicationController

  layout :choose_layout

  def choose_layout
    action_name == "horizontal" ? "horizontal" : "vertical"
  end

  def compact
  end

  def detached
  end

  def full
  end

  def fullscreen
  end

  def horizontal
  end

  def hover
  end

  def icon_view
  end
end
