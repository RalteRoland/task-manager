class Api::StatusesController < ApplicationController
  def index
    render json: Status.order(:name)
  end
end
