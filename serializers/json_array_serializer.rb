# frozen_string_literal: true

require "json"

# Is only used for testing purposes
class JsonArraySerializer
  def self.dump(array)
    array.to_json
  end

  def self.load(json_string)
    json_string ? JSON.parse(json_string) : []
  end
end
