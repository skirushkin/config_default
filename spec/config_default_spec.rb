# frozen_string_literal: true

describe ConfigDefault do
  describe "#configure" do
    it "can change config_path and postfix" do
      described_class.configure do |config|
        config.config_path = "./other_config_path"
        config.postfix = "not_default"
      end

      expect(described_class.config.config_path).to eq("./other_config_path")
      expect(described_class.config.postfix).to eq("not_default")

      described_class.configure do |config|
        config.config_path = "./spec/config_examples"
        config.postfix = "default"
      end
    end
  end

  describe "#load" do
    it "loads config from example1" do
      expect(described_class.load(:example1)).to eq("first" => "one", "second" => "example")
    end

    it "loads config from example2" do
      expect(described_class.load(:example2)).to eq("first" => "one")
    end

    it "loads config from example3" do
      expect(described_class.load(:example3)).to eq("second" => "two")
    end

    it "loads config from example1 and symbolize_keys" do
      expect(described_class.load(:example1, symbolize_keys: true)).to \
        eq(first: "one", second: "example")
    end

    it "does not fail on empty key symbolization" do
      expect(described_class.load(:example1, key: "incorrect", symbolize_keys: true)).to eq({})
      expect(described_class.load(:example1, key: "incorrect", deep_symbolize_keys: true)).to eq({})
    end
  end

  describe "#load_struct" do
    describe "#to_hash" do
      it "convert different options to different hash" do
        config = described_class.load_struct(:nested, recursive: true)

        expect(config.first.to_hash).to eq("second" => { "third" => "three" })
        expect(config.first.second.to_hash).to eq("third" => "three")
      end
    end

    context "default" do
      it "loads correct struct from example1" do
        config = described_class.load_struct(:example1)

        expect(config.first).to eq("one")
        expect(config.second).to eq("example")
        expect { config.third }.to raise_error(ArgumentError)
      end
    end

    context "recursive: true" do
      it "loads correct struct from nested" do
        config = described_class.load_struct(:nested, recursive: true)

        expect(config.first.second.third).to eq("three")
      end
    end

    context "allow_nil: true" do
      it "loads correct struct from example1" do
        config = described_class.load_struct(:example1, allow_nil: true)

        expect(config.first).to eq("one")
        expect(config.second).to eq("example")
        expect(config.third).to eq(nil)
      end
    end
  end
end

ConfigDefault.apply_rails_patch!
make_rails_app

describe ConfigDefault::RailsApplicationPatch do
  describe "#config_for" do
    it "load configuration in rails style" do
      config = Rails.application.config_for(:nested)

      expect(config.class).to eq(ActiveSupport::OrderedOptions)
      expect(config[:first]).to eq(second: { third: "three" })
      expect(config["first"]).to eq(second: { third: "three" })
    end
  end
end

describe ConfigDefault::RailsApplicationConfigurationPatch do
  describe "#load_database_yaml" do
    it "load database configuration in rails style" do
      expect(Rails.application.config.load_database_yaml).to eq(
        "development" => { "host" => "localhost", "database" => "example" },
      )
    end
  end

  describe "#database_configuration" do
    it "load database configuration in rails style" do
      expect(Rails.application.config.database_configuration).to eq(
        "development" => { "host" => "localhost", "database" => "example" },
      )
    end
  end
end
