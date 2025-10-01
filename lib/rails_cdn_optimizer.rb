require 'ostruct'
require "rails_cdn_optimizer/analyzer"

module RailsCdnOptimizer
  class Error < StandardError; end

  class << self
    attr_accessor :config

    def configure
      self.config ||= OpenStruct.new
      yield(config)
    end
  end
end
