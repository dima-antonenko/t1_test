# frozen_string_literal: true

# базовый класс для связи с БД
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
