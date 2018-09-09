require 'sphynx/services/base_auth_service'

include ConfigurationHelper

RSpec.describe Sphynx::BaseAuthService do
  let(:request) { instance_double('request') }
  let(:warden) { instance_double('warden') }
  let(:provider_class) { class_double('AuthProvider') }
  let(:provider_instance) { instance_double('AuthProvider') }
  let(:user_hash) { { 'sub' => 'id' } }
  let(:user) { User.new }

  describe '.authenticate!' do
    before(:each) do
      configure_sphynx

      allow(Sphynx::BaseAuthService).to receive(:get_user_hash).and_return(user_hash)
      allow(Sphynx::BaseAuthService).to receive(:provider).and_return('google')
      allow(request).to receive(:env).and_return('warden' => warden)
    end

    context 'when the user is found' do
      it 'should set the user in warden and call hooks' do
        expect(provider_class).to receive(:find_for_auth).with('google', 'id').and_return(provider_instance)
        expect(provider_instance).to receive(:user).and_return(user)
        expect(warden).to receive(:set_user).with(user, scope: :user)
        expect(user).to receive(:after_authentication).with('google', request, user_hash)

        Sphynx::BaseAuthService.authenticate!(:user, 'token', request, false)
      end
    end

    context 'when the user is not found' do
      before(:each) do
        allow(provider_class).to receive(:find_for_auth).and_return(nil)
      end

      it 'should create the user on the fly if we allow it' do
        allow(warden).to receive(:set_user)
        expect(User).to receive(:create_from_auth).with('google', request, user_hash)

        Sphynx::BaseAuthService.authenticate!(:user, 'token', request, true)
      end

      it 'should raise an error if user creation is disabled' do
        expect { Sphynx::BaseAuthService.authenticate!(:user, 'token', request, false) }.to raise_error(Sphynx::UserNotFoundError)
      end
    end
  end

  describe '.provider' do
    it 'should raise a NoMethodError' do
      expect { Sphynx::BaseAuthService.provider }.to raise_error(NoMethodError)
    end
  end

  describe '.get_user_hash' do
    it 'should raise a NoMethodError' do
      expect { Sphynx::BaseAuthService.get_user_hash('token') }.to raise_error(NoMethodError)
    end
  end
end
