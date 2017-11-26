RSpec.describe Sphynx do
  it 'has a version number' do
    expect(Sphynx::VERSION).not_to be nil
  end

  describe '.configuration' do
    it 'should return the configuration object' do
      expect(Sphynx.configuration).to be_a(Sphynx::Configuration)
    end
  end

  describe '.reset' do
    it 'should reset configuration to default values' do
      Sphynx.configure do |config|
        config.dispatch_requests = [['POST', /^login$/]]
        config.revocation_requests = [['GET', /^logout$/]]
        config.secret = 'super_secret'
        config.scopes = {
          admin: { user_class: User, provider_class: AuthProvider, revocation_strategy: DummyRevocationStrategy }
        }
      end

      Sphynx.reset

      default_config = {
        dispatch_requests: [],
        revocation_requests: [],
        secret: nil,
        scopes: {
          user: {
            user_class: User,
            provider_class: AuthProvider,
            revocation_strategy: Sphynx::RevocationStrategies::NullStrategy
          }
        }
      }

      expect(Sphynx.configuration).to have_attributes(default_config)
    end
  end

  describe '.configure' do
    it 'should raise an error if no secret is provided' do
      block = ->(_) {}
      expect { Sphynx.configure(&block) }.to raise_error(RuntimeError)
    end

    it 'should yield with the configuration object' do
      block = ->(config) { config.secret = 'secret' }
      expect { Sphynx.configure(&block) }.not_to raise_error
      expect { |b| Sphynx.configure(&b) }.to yield_with_args(Sphynx.configuration)
    end
  end
end
