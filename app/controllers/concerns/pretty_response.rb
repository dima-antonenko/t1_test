# frozen_string_literal: true

# модуль чтобы красиво сократить содержимое контроллера
module PrettyResponse
  # def render_response(result, serializer = nil)
  #   if result.is_a?(ActiveRecord::Base) # eсли результат положителен
  #     render_item(result)
  #   elsif result.is_a?(ActiveModel::Errors)
  #     render_errors(result, 422)
  #   elsif result.nil?
  #     render_forbidden
  #   else
  #     render_json({result: result.to_s, attr: result.instance_variables.to_s}, 422)
  #   end
  # end

  def render_collection(item, options = {})
    render_errors(item, 422) and return if item.is_a?(ActiveModel::Errors)
    render_forbidden and return  if item.nil?

    serializer = build_serializer(item, options.fetch(:serializer, nil))
    prm = { current_user: current_user }.merge(options.fetch(:extra_params, {}))

    output = { items: serializer.render_as_hash(item, prm) }
    output[:meta] = options.fetch(:meta, nil)
    render_json(output)
  end

  def render_item(item, options = {})
    render_errors(item, 422) and return if item.is_a?(ActiveModel::Errors)
    render_forbidden and return  if item.nil?

    serializer = build_serializer(item, options.fetch(:serializer, nil))
    prm = {}.merge(options.fetch(:extra_params, {}))

    output = serializer.render_as_hash(item, prm)
    render_json(output)
  end

  def render_errors(errors, code)
    render_json({ errors: errors }, code)
  end

  def render_forbidden
    render_json({ message: "Something went wrong" }, 500)
  end

  def render_json(json = {}, code = 200)
    render(json: json, status: code)
  end

  def render_json_item(key, value)
    render json: { key => value }
  end

  private

  def get_serializer(item, serializer)
    serializer || serializer_class(item)
  end

  def serializer_class(item)
    if item.is_a?(ActiveRecord::Base) # if one record
      "#{item.class.name}Blueprint"
    elsif !item.empty? # if collection
      "#{item.first.class.name}Blueprint"
    end
  end

  def build_serializer(item, serializer_class)
    get_serializer(item, serializer_class).classify.safe_constantize
  end
end
