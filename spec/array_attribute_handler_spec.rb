# frozen_string_literal: true

require_relative "../serializers/json_array_serializer"
require "support/shared_examples/array_attribute_handler_shared"
require "active_record"

RSpec.describe ArrayAttributeHandler do
  it "has a version number" do
    expect(ArrayAttributeHandler::VERSION).not_to be nil
  end

  describe "when the concern is applied to a model" do
    let(:dummy_model_class) do
      # This is a dummy model to test the concern on.
      Class.new(ActiveRecord::Base) do
        serialize :array_attribute_a, JsonArraySerializer
        serialize :array_attribute_b, JsonArraySerializer
        serialize :array_attribute_c, JsonArraySerializer

        include ArrayAttributeHandler

        handle_array_attribute :array_attribute_a
        handle_array_attribute :array_attribute_b, { separator: "|" }
        handle_array_attribute :array_attribute_c, { separator: ",", spaced_join: true }
      end
    end

    before do
      stub_const("DummyModel", dummy_model_class)

      # Establish a connection to an SQLite in-memory database
      DummyModel.establish_connection(adapter: "sqlite3", database: ":memory:")
      DummyModel.connection.create_table(:dummy_models) do |t|
        t.string :array_attribute_a
        t.string :array_attribute_b
        t.string :array_attribute_c
      end
    end

    after do
      DummyModel.connection.drop_table(:dummy_models)
    end

    describe "#handle_array_attribute" do
      let(:dummy_model_instance) { DummyModel.new }

      describe "when no separator is specified" do
        it "parses strings with Windows-style newline characters" do
          values_string = "Value1\r\nValue2\r\nValue3"
          dummy_model_instance.send("array_attribute_a=", values_string)
          expect(dummy_model_instance.array_attribute_a).to eq(%w[Value1 Value2 Value3])
        end

        it "parses strings with old Mac OS-style newline characters" do
          values_string = "Value1\rValue2\rValue3"
          dummy_model_instance.send("array_attribute_a=", values_string)
          expect(dummy_model_instance.array_attribute_a).to eq(%w[Value1 Value2 Value3])
        end

        it "parses strings with Unix-style newline characters" do
          values_string = "Value1\nValue2\nValue3"
          dummy_model_instance.send("array_attribute_a=", values_string)
          expect(dummy_model_instance.array_attribute_a).to eq(%w[Value1 Value2 Value3])
        end
      end
    end

    it_behaves_like "ArrayAttributeHandler", -> { DummyModel }, :array_attribute_a
    it_behaves_like "ArrayAttributeHandler", -> { DummyModel }, :array_attribute_b, { separator: "|" }
    it_behaves_like "ArrayAttributeHandler", -> { DummyModel }, :array_attribute_c, {
      separator: ",", spaced_join: true
    }
  end
end
