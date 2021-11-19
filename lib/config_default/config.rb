# frozen_string_literal: true

ConfigDefault::Config = Struct.new(:config_path, :postfix) do
  def initialize
    self.config_path = "./config"
    self.postfix = "default"
  end
end
