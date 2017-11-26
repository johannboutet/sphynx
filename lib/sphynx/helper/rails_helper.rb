require 'active_support/concern'

module Sphynx
  module RailsHelper
    extend ActiveSupport::Concern

    included do
      Sphynx.configuration.scopes.keys.each do |scope|
        define_method(:"authenticate_#{scope}!") { authenticate!(scope) }
        define_method(:"current_#{scope}") { warden.user(scope) }
        define_method(:"#{scope}_signed_in?") { signed_in?(scope) }
      end
    end

    def warden
      request.env['warden']
    end

    def authenticate!(scope)
      warden.authenticate!(:jwt, scope: scope)
    end

    def signed_in?(scope)
      warden.authenticated?(scope)
    end
  end
end
