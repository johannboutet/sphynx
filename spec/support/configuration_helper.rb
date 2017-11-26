module ConfigurationHelper
  def configure_sphynx
    provider = defined?(provider_class) ? provider_class : AuthProvider

    Sphynx.configure do |config|
      config.dispatch_requests = [['POST', /^login$/]]
      config.revocation_requests = [['GET', /^logout$/]]
      config.secret = 'super_secret'
      config.scopes = {
        user: { user_class: User, provider_class: provider, revocation_strategy: DummyRevocationStrategy },
        admin: { user_class: User, provider_class: provider, revocation_strategy: DummyRevocationStrategy }
      }
      config.google_client_id = 'google_id'
    end
  end
end
