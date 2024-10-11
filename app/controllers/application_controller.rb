class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include PrettyResponse

  rescue_from 'RelationError' do |exception|
    render json: {errors: exception.call}, status: 500
  end

  rescue_from 'PermissionError' do |exception|
    render json: {errors: exception.call}, status: 422
  end

  rescue_from 'ParamsValidationError' do |exception|
    render json: {errors: exception.call}, status: 422
  end

  rescue_from 'ForbiddenError' do |exception|
    render json: {errors: exception.call}, status: 500
  end

  rescue_from 'ActiveRecord::RecordNotFound'  do |exception|
    render json: {errors: 'Record not found'}, status: 404
  end
end
