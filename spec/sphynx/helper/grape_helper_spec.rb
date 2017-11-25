RSpec.describe Sphynx::Helper::GrapeHelper do
  let(:target) { Target.new }
  let(:request) { instance_double('request') }

  before(:all) do
    Sphynx.configure do |config|
      config.dispatch_requests = [['POST', /^login$/]]
      config.revocation_requests = [['GET', /^logout$/]]
      config.secret = 'super_secret'
      config.scopes = {
        user: { repository: User, revocation_strategy: DummyRevocationStrategy },
        admin: { repository: User, revocation_strategy: DummyRevocationStrategy }
      }
    end

    class Target
      include Sphynx::Helper::GrapeHelper
    end
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
      allow(request).to receive(:env).and_return({ 'warden' => 'the request warden' })
      allow(target).to receive(:request).and_return(request)

      expect(target.warden).to eq('the request warden')
    end
  end
end
