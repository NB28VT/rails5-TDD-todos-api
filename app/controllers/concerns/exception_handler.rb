module ExceptionHandler
  # Allows us to use the "included" method instead of all this:
  # def self.included(base)
    # base.extend ClassMethods
    # base.class_eval do

  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({message: e.message}, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({message: e.message}, :unprocessable_entity)
    end
  end
end
