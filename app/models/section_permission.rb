class SectionPermission < ApplicationRecord
  belongs_to :section
  belongs_to :permission

  def self.ransackable_attributes(auth_object = nil)
    %w[id section_id permission_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[section permission]
  end
end
