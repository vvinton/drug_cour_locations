class BjaController < ApplicationController
  ActionController::Parameters.permit_all_parameters = true
  def index
    @results = BjaGrant.all.page(page).per(per)
  end

  def page
    @page ||= params.fetch(:page, 1)
  end

  def per
    @per ||= params.fetch(:per, 20)
  end
end
