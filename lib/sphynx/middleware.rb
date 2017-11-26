module Sphynx
  class Middleware
    attr_reader :app

    def initialize(app)
      @app = app
    end

    def call(env)
      default_scope = Sphynx.configuration.scopes.keys.first

      builder = Rack::Builder.new
      builder.use(Warden::Manager) do |manager|
        manager.default_strategies :jwt
        manager.default_scope = default_scope
        manager.scope_defaults(default_scope, store: false, strategies: [:jwt])
        manager.failure_app = Sphynx.configuration.failure_app
      end
      builder.use(Warden::JWTAuth::Middleware)
      builder.run(app)
      builder.call(env)
    end
  end
end
