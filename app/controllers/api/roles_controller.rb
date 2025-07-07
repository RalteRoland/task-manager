class Api::RolesController < ApplicationController
  def index
    render json: Role.order(:name)
  end
end
