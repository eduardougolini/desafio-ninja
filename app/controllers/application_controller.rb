# frozen_string_literal: true

# Base controller for the project
class ApplicationController < ActionController::API
  around_action :define_locale
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param

  def define_locale
    I18n.locale = if I18n.available_locales.include?(params['locale']&.to_sym)
                    params['locale']
                  else
                    I18n.default_locale
                  end
    yield
  end

  def not_found
    head :not_found
  end

  def missing_param
    render json: { error: I18n.t('errors.messages.missing_param') }, status: :bad_request
  end
end
