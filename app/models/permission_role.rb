class PermissionRole < ApplicationRecord
  belongs_to :role
  belongs_to :section

  def self.actions
    %w[view create edit destroy]
  end
end
