require 'sphynx/services/google_auth_service'

RSpec.describe Sphynx::GoogleAuthService do
  include ConfigurationHelper

  before(:all) do
    configure_sphynx
  end

  describe '.provider' do
    it 'should be google' do
      expect(Sphynx::GoogleAuthService.provider).to eq('google')
    end
  end

  describe '.get_user_hash' do
    context 'when the Google token is valid' do
      it 'should return the user data' do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check).with('token', 'google_id', 'google_id').and_return(email: 'test@example.com', id: 'd25e8113-51d8-4489-b4b1-a9f30f4f3ddb')

        expect(Sphynx::GoogleAuthService.get_user_hash('token')).to eq(email: 'test@example.com', id: 'd25e8113-51d8-4489-b4b1-a9f30f4f3ddb')
      end
    end

    context 'when the Google token is not valid' do
      it 'should raise a Sphynx::InvalidTokenError error' do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check).with('token', 'google_id', 'google_id').and_raise(GoogleIDToken::ValidationError)

        expect { Sphynx::GoogleAuthService.get_user_hash('token') }.to raise_error(Sphynx::InvalidTokenError)
      end
    end
  end
end
