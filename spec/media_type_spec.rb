require 'yaml'
require 'spec_helper'

fixtures = YAML.load_file("#{File.dirname(__FILE__)}/fixtures.yml")

describe MediaType do
  it "has a version number" do
    expect(MediaType::VERSION).not_to be nil
  end

  describe "#to_h" do
    fixtures.each do |string, orig|
      it "reproduces #{string} hash" do
        hash = MediaType.new(orig).to_h
        [:type, :tree, :subtype, :suffix, :parameters].each do |key|
          expect(hash).to have_key(key)
          expect(hash[key]).to eq orig[key.to_s]
        end
      end
    end
  end

  describe "#parse" do
    context "with parse_parameters enabled" do
      fixtures.each do |string, hash|
        it "correctly parses #{string}" do
          type = MediaType.parse(string)
          [:type, :tree, :subtype, :suffix, :parameters].each do |key|
            expect(type.send(key)).to eq hash[key.to_s]
          end
        end
      end
    end

    context "with parse_parameters disabled" do
      fixtures.each do |string, hash|
        it "correctly parses #{string}" do
          type = MediaType.parse(string, parse_parameters: false)
          [:type, :tree, :subtype, :suffix].each do |key|
            expect(type.send(key)).to eq hash[key.to_s]
          end
          expect(type.parameters).to eq string.split(?;, 2)[1]
        end
      end
    end
  end

  describe "#==" do
    context "when types are equal" do
      input1 = %{text/html ; charset=utf-8}
      input2 = %{text/html; charset="utf-8"}
      [true, false].repeated_permutation(2) do |parse1, parse2|
        context "with parse_parameters set to #{parse1} for input1 and #{parse2} for input2" do
          it "returns true" do
            type1 = MediaType.parse(input1, parse_parameters: parse1)
            type2 = MediaType.parse(input2, parse_parameters: parse2)
            expect(type1).to eq type2
          end
        end
      end
    end

    context "when types are not equal" do
      it "returns false" do
        expect(MediaType.parse("text/html")).not_to eq MediaType.parse("image/png")
      end
    end
  end

  describe "#to_s" do
    context "with hash parameters" do
      fixtures.each do |string, _|
        it "reproduces #{string}" do
          type = MediaType.parse(string)
          expect(MediaType.parse(type.to_s)).to eq type
        end
      end
    end

    context "with string parameters" do
      fixtures.each do |string, _|
        it "reproduces an equivalent to #{string}" do
          type = MediaType.parse(string, parse_parameters: false)
          expect(MediaType.parse(type.to_s)).to eq type
        end
      end
    end
  end

  describe "#inspect" do
    it "is correctly formatted" do
      type = MediaType.parse("text/html")
      expect(type.inspect).to eq "#<MediaType:text/html>"
    end
  end

  describe "#parsed_parameters" do
    context "when value is nil" do
      it "returns nil" do
        expect(MediaType.new.parsed_parameters).to be_nil
      end
    end
  end
end
