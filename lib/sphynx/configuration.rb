module Sphynx
  class Configuration
    attr_accessor :dispatch_routes, :revoke_routes

    def initialize
      @dispatch_routes = []
      @revoke_routes = []
    end
  end
end
