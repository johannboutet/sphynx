# frozen_string_literal: true

require 'sphynx/services/base_auth_service'
require 'google-id-token'

module Sphynx
  class GoogleAuthService < BaseAuthService
    PROVIDER = 'google'

    def self.get_user_hash(token)
      validator = GoogleIDToken::Validator.new
      client_id = Sphynx.configuration.google_client_id

      begin
        payload = validator.check(token, client_id, client_id)
      rescue GoogleIDToken::ValidationError => e
        raise InvalidTokenError, e
      end

      payload
    end
  end
end
