# frozen_string_literal: true

require_relative "array_attribute_handler/version"
require "active_support/concern"

module ArrayAttributeHandler
  extend ActiveSupport::Concern

  class_methods do
    def handle_array_attribute(attribute_name, options = {})
      cattr_accessor :array_attributes
      self.array_attributes ||= []
      self.array_attributes << attribute_name

      separator = options.fetch(:separator, "\n")
      combinator = separator + (options.fetch(:spaced_join, false) ? " " : "")

      # Override setter method
      define_method("#{attribute_name}=") do |value|
        super(parse_values(value, separator))
      end

      # Define getter for "_text"
      define_method("#{attribute_name}_text") do
        send(attribute_name).join(combinator)
      end

      # Define setter for "_text"
      define_method("#{attribute_name}_text=") do |value|
        send("#{attribute_name}=", parse_values(value, separator))
      end
    end
  end

  private

  def parse_values(value, separator)
    array = value.is_a?(String) ? value.split(separator) : value.to_a
    array.map { |v| v.strip.presence }.compact
  end
end
