class HierarchyController < ApplicationController
    def partners
      partners = User.where(parent_id: params[:id], hierarchy_level: :partner)
      render json: partners.select(:id, :full_name).map { |u| { id: u.id, name: u.full_name } }
    end
  
    def collectors
      collectors = User.where(parent_id: params[:id], hierarchy_level: :collector)
      render json: collectors.select(:id, :full_name).map { |u| { id: u.id, name: u.full_name } }
    end
  
    def collections
      collections = Collection.joins(:collection_users).where(collection_users: { user_id: params[:id] })
      render json: collections.select(:id, :name)
    end
  end
  