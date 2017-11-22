module Sphynx::RevocationStrategies
  class NullStrategy
    def self.jwt_revoked?(*_)
      false
    end

    def self.revoke_jwt(*_); end
  end
end
