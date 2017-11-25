RSpec.describe Sphynx::RevocationStrategies::NullStrategy do
  describe '.jwt_revoked?' do
    it 'should return false' do
      expect(Sphynx::RevocationStrategies::NullStrategy.jwt_revoked?('payload', 'user')).to eq(false)
    end
  end
end
