# frozen_string_literal: true

module Sphynx
  class BaseAuthenticationService
    PROVIDER = nil

    def self.authenticate!(scope, token, request, create_if_not_found = true)
      user_hash = get_user_hash(token)
      auth_provider = Sphynx.configuration.scopes[scope].provider_class.public_send("find_for_#{PROVIDER}_auth", PROVIDER, user_hash['sub'])

      raise UserNotFoundError unless auth_provider || create_if_not_found

      user = if auth_provider
        auth_provider.public_send(scope)
      else
        Sphynx.configuration.scopes[scope].user_class.public_send("create_from_#{PROVIDER}_auth", PROVIDER, user_hash)
      end

      request.env['warden'].set_user(user, scope: scope)
      user.after_authentication(PROVIDER, request, user_hash) if user.respond_to?(:after_authentication)
      user
    end

    def self.get_user_hash(_)
      raise NoMethodError, 'Each authentication service must implement this method in its own way'
    end
  end

  class InvalidToken < StandardError
  end

  class UserNotFoundError < StandardError
  end
end
