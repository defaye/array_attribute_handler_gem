# frozen_string_literal: true

require_relative "array_attribute_handler/version"
require "active_support/concern"

# Public: ArrayAttributeHandler is a module for handling array attributes.
module ArrayAttributeHandler
  extend ActiveSupport::Concern

  class_methods do
    # Public: Handle array attributes.
    #
    # attribute_name - The name of the attribute to handle.
    # options - The options hash.
    #           :separator - The separator to use when parsing the attribute.
    #                        Defaults to "\n".
    #           :spaced_join - Whether to join the parsed values with a space.
    #                          Defaults to false.
    def handle_array_attribute(attribute_name, options = {})
      separator = options.fetch(:separator, "\n")

      # Public: Setter for the attribute.
      define_method("#{attribute_name}=") do |value|
        super(parse_values(value, separator))
      end

      # Public: Getter for the text representation of the attribute.
      define_method("#{attribute_name}_text") do
        send(attribute_name).join(separator + (options.fetch(:spaced_join, false) ? " " : ""))
      end

      # Public: Setter for the text representation of the attribute.
      define_method("#{attribute_name}_text=") do |value|
        send("#{attribute_name}=", parse_values(value, separator))
      end
    end
  end

  private

  # Internal: Parse the given value into an array of strings.
  #
  # value - The value to parse.
  # separator - The separator to use when parsing the value.
  #
  # Returns an array of strings.
  def parse_values(value, separator)
    array = value.is_a?(String) ? value.split(separator) : value.to_a
    # Remove any empty strings from the array.
    array.map { |v| v.strip.presence }.compact
  end
end
