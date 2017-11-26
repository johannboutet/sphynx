require 'active_support/concern'

module Sphynx
  module RailsHelper
    module SecurityMethods
      extend ActiveSupport::Concern

      included do
        Sphynx.configuration.scopes.keys.each do |scope|
          define_method(:"authenticate_#{scope}!") { warden.authenticate!(:jwt, scope: scope) }
          define_method(:"current_#{scope}") { warden.user(scope) }
          define_method(:"#{scope}_signed_in?") { warden.authenticated?(scope) }
        end
      end

      def warden
        request.env['warden']
      end
    end
  end
end
