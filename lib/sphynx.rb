require 'sphynx/configuration'
require 'sphynx/revocation_strategies/null_strategy'
require 'sphynx/middleware/grape_middleware'
require 'sphynx/version'

require 'warden/jwt_auth'

module Sphynx
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)

    raise RuntimeError, 'You must configure a secret' unless configuration.secret
    raise RuntimeError, 'You must configure at least one scope' unless configuration.scopes

    mappings = {}
    revocation_strategies = {}

    configuration.scopes.each do |scope, config|
      mappings[scope] = config[:repository]
      revocation_strategies[scope] = config[:revocation_strategy]
    end

    Warden::JWTAuth.configure do |config|
      config.secret = configuration.secret
      config.mappings = mappings
      config.revocation_strategies = revocation_strategies
      config.dispatch_requests = configuration.dispatch_requests
      config.revocation_requests = configuration.revocation_requests
    end
  end
end
