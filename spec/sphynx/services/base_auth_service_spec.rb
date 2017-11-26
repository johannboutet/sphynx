RSpec.describe Sphynx::BaseAuthenticationService do
  describe '.get_user_hash' do
    it 'should have no provider' do
      expect(Sphynx::BaseAuthenticationService::PROVIDER).to be_nil
    end

    it 'should raise a NoMethodError' do
      expect { Sphynx::BaseAuthenticationService.get_user_hash('token') }.to raise_error(NoMethodError)
    end
  end
end
