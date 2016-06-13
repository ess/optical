require "../spec_helper"

module Optical
  describe Parser do
    let(:described_class) {Optical::Parser}
    let(:parser) {described_class.new}

    describe "parse" do
      let(:parse) {parser.parse(args)}
      let(:args) {["--help", "-c", "file", "blah", "-n"]}
      let(:results) { {} of Symbol => Bool?|String? }

      before do
        parser.flag(:no_newline) do |no_newline|
          no_newline.short = "-n"
          no_newline.long = "--no-newline"

          no_newline.action do |value|
            results[no_newline.name] = value
          end
        end

        parser.flag(:help) do |help|
          help.short = "-h"
          help.long = "--help"

          help.action {results[:help] = true}
        end

        parser.flag(:config) do |config|
          config.short = "-c"
          config.long = "--config"
          config.argument = "config_file"

          config.action do |value|
            results[:config] = value
          end
        end
      end

      it "is an Array" do
        expect(parse).to be_a(Array(String))
      end

      it "stops processing at the first unknown token" do
        expect(parse).to eq(["blah", "-n"])
      end

      it "runs the defined callbacks for processed flags" do
        parse
        expect(results[:help]?).not_to be_nil
        expect(results[:config]?).not_to be_nil
      end
    end
  end
end
