module Sphynx
  module Grape
    module SecurityHelper
      def warden
        request.env['warden']
      end

      def self.included(_)
        Sphynx.configuration.scopes.keys.each do |scope|
          define_method(:"authenticate_#{scope}!") { warden.authenticate!(:jwt, scope: scope) }
          define_method(:"current_#{scope}") { warden.user(scope) }
          define_method(:"#{scope}_signed_in?") { warden.authenticated?(scope) }
        end
      end
    end
  end
end
