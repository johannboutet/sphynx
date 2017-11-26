RSpec.describe Sphynx::GrapeHelper do
  let(:target) { Target.new }
  let(:warden) { instance_double('warden') }

  before(:all) do
    Sphynx.configure do |config|
      config.dispatch_requests = [['POST', /^login$/]]
      config.revocation_requests = [['GET', /^logout$/]]
      config.secret = 'super_secret'
      config.scopes = {
        user: { user_class: User, provider_class: AuthProvider, revocation_strategy: DummyRevocationStrategy },
        admin: { user_class: User, provider_class: AuthProvider, revocation_strategy: DummyRevocationStrategy }
      }
    end

    class Target
      include Sphynx::GrapeHelper
    end
  end

  before(:each) do
    allow(target).to receive(:env).and_return({ 'warden' => warden })
  end

  it 'should define helper methods for each scope' do
    expect(target.respond_to?(:warden)).to be(true)

    expect(target.respond_to?(:authenticate_user!)).to be(true)
    expect(target.respond_to?(:current_user)).to be(true)
    expect(target.respond_to?(:user_signed_in?)).to be(true)

    expect(target.respond_to?(:authenticate_admin!)).to be(true)
    expect(target.respond_to?(:current_admin)).to be(true)
    expect(target.respond_to?(:admin_signed_in?)).to be(true)
  end

  describe '#warden' do
    it 'should return the request\'s warden' do
      expect(target.warden).to eq(warden)
    end
  end

  describe '#authenticate!' do
    it 'should call warden for authentication' do
      expect(warden).to receive(:authenticate!).with(:jwt, scope: :user)

      target.authenticate!(:user)
    end
  end

  describe '#signed_in?' do
    it 'should call warden to get authentication state' do
      expect(warden).to receive(:authenticated?).with(:user)

      target.signed_in?(:user)
    end
  end
end
