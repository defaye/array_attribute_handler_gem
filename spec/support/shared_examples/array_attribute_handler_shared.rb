# frozen_string_literal: true

require "support/shared_examples/array_attribute_handler_shared"

RSpec.shared_examples "ArrayAttributeHandler" do |model_lambda, attribute_name, options = {}|
  subject(:model_instance) do
    model_class = model_lambda.call
    model_class.new
  end

  separator = options.fetch(:separator, /\r\n?|\n/)
  delimiter = separator.is_a?(Regexp) && separator.match?("\r\n|\r|\n") ? "\n" : separator
  combinator = delimiter + (options.fetch(:spaced_join, false) ? " " : "")

  describe "##{attribute_name}=" do
    context "when provided with a string separated by the specified separator" do
      it "parses it into an array" do
        values_string = "Value1#{combinator}Value2#{combinator}Value3"
        model_instance.send("#{attribute_name}=", values_string)
        expect(model_instance.send(attribute_name)).to eq(%w[Value1 Value2 Value3])
      end
    end

    context "when values are empty" do
      it "strips the values" do
        values_string = "Value1#{combinator}#{combinator} #{combinator}"
        model_instance.send("#{attribute_name}=", values_string)
        expect(model_instance.send(attribute_name)).to eq(%w[Value1])
      end
    end

    context "when values have extra whitespace" do
      it "strips the values" do
        values_string = " Value1 #{combinator} Value2 "
        model_instance.send("#{attribute_name}=", values_string)
        expect(model_instance.send(attribute_name)).to eq(%w[Value1 Value2])
      end
    end

    context "when value is nil" do
      it "handles it without error" do
        model_instance.send("#{attribute_name}=", nil)
        expect(model_instance.send(attribute_name)).to eq([])
      end
    end
  end

  describe "##{attribute_name}_text" do
    it "returns the joined string representation of the attribute values" do
      model_instance.send("#{attribute_name}=", %w[Value1 Value2 Value3])
      expect(model_instance.send("#{attribute_name}_text")).to eq("Value1#{combinator}Value2#{combinator}Value3")
    end
  end

  describe "##{attribute_name}_text=" do
    it "parses the string value and sets the attribute" do
      model_instance.send("#{attribute_name}_text=", "Value1#{combinator}Value2#{combinator}Value3")
      expect(model_instance.send(attribute_name)).to eq(%w[Value1 Value2 Value3])
    end
  end
end
