# frozen_string_literal: true

# базовый класс приложения
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include PrettyResponse

  rescue_from "RelationError" do |exception|
    render json: { errors: exception.call }, status: :internal_server_error
  end

  rescue_from "PermissionError" do |exception|
    render json: { errors: exception.call }, status: :unprocessable_content
  end

  rescue_from "ParamsValidationError" do |exception|
    render json: { errors: exception.call }, status: :unprocessable_content
  end

  rescue_from "ForbiddenError" do |exception|
    render json: { errors: exception.call }, status: :internal_server_error
  end

  rescue_from "ActiveRecord::RecordNotFound" do |_exception|
    render json: { errors: "Record not found" }, status: :not_found
  end
end
