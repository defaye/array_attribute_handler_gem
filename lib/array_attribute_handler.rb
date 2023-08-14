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
    #                        Defaults to newline characters.
    #           :spaced_join - Whether to join the parsed values with a space.
    #                          Defaults to false.
    def handle_array_attribute(attribute_name, options = {})
      separator = options.fetch(:separator, /\r\n?|\n/)

      define_method("#{attribute_name}=") do |value|
        super(parse_values(value, separator))
      end

      # Public: Getter for the text representation of the attribute.
      define_method("#{attribute_name}_text") do
        send(attribute_name).join(determine_delimiter(separator) + (options.fetch(:spaced_join, false) ? " " : ""))
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

  # Internal: Determine the delimiter to use when parsing the attribute.
  #
  # separator - The separator to use when parsing the attribute.
  #
  # Returns the delimiter to use when parsing the attribute.
  def determine_delimiter(separator)
    if separator.is_a?(Regexp) && separator.match?("\r\n|\r|\n")
      # Check for a specific condition you want to match, e.g., a regex that matches both \r and \n
      return "\n"
    end

    separator # Return the separator as-is if it's not a regex or doesn't match the condition
  end
end
