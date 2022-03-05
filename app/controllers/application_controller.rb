# frozen_string_literal: true

# Base controller for the project
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param

  def not_found
    head :not_found
  end

  def missing_param
    render json: { error: I18n.t('errors.messages.missing_param') }, status: :unprocessable_entity
  end
end
