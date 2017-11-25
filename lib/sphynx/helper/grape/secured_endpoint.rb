module Sphynx
  module Grape
    module SecuredEndpoint
      def self.included(base)
        base.before do
          unless options[:route_options][:allow_anonymous]
            scope = options[:route_options][:scope] || Sphynx.configuration.scopes.keys.first

            self.public_send(:"authenticate_#{scope}!")
          end
        end
      end
    end
  end
end
