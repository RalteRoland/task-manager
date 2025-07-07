class Api::PrioritiesController < ApplicationController
  def index
    render json: Priority.order(:name)
  end
end
