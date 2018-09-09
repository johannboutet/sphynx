module Sphynx
  module GrapeHelper
    def self.included(_)
      Sphynx.configuration.scopes.each do |key, scope|
        define_method(:"authenticate_#{key}!") { authenticate!(key) }
        define_method(:"current_#{key}") { scope[:user_class].find(warden.user(scope).id) }
        define_method(:"#{key}_signed_in?") { signed_in?(key) }
      end
    end

    def warden
      env['warden']
    end

    def authenticate!(scope)
      warden.authenticate!(:jwt, scope: scope)
    end

    def signed_in?(scope)
      warden.authenticated?(scope)
    end
  end
end
