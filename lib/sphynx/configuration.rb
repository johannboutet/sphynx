module Sphynx
  class Configuration
    attr_reader :dispatch_requests, :revocation_requests, :scopes
    attr_accessor :secret

    METHODS = %w[HEAD GET POST PUT PATCH DELETE OPTIONS]

    def initialize
      @dispatch_requests = []
      @revocation_requests = []
      @secret = nil
      @scopes = {
        user: {
          repository: User,
          revocation_strategy: Sphynx::RevocationStrategies::NullStrategy
        }
      }
    end

    def dispatch_requests=(routes)
      validate_routes_config!(routes)
      @dispatch_requests = routes
    end

    def revocation_requests=(routes)
      validate_routes_config!(routes)
      @revocation_requests = routes
    end

    def scopes=(value)
      raise ArgumentError, 'You have to specify at least one scope' unless value.is_a?(Hash) && value.keys.any?
      raise ArgumentError, 'A scope must have a repository' unless value.values.all? { |scope| scope.key?(:repository) }

      value.values.map! do |scope|
        scope[:revocation_strategy] ||= Sphynx::RevocationStrategies::NullStrategy
        scope
      end

      @scopes = value
    end

    private

    def validate_routes_config!(routes)
      raise ArgumentError, 'Dispatch and revoke routes should be an array' unless routes.is_a?(Array)
      raise ArgumentError, 'All dispatch and revoke routes elements should have the form [HTTP_VERB, regex]' unless routes.all? { |route| route.length == 2 && METHODS.include?(route[0]) && route[1].is_a?(Regexp) }
    end
  end
end
