class Api::RolesController < ApplicationController
    def index
      roles = Role.all.order(:name)
      render json: roles.select(:id, :name)
    end
end
