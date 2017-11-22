require 'spec_helper'

RSpec.describe Sphynx do
  it 'has a version number' do
    expect(Sphynx::VERSION).not_to be nil
  end

  context 'configuration methods' do
    let(:expected_config) {
      {
        dispatch_routes: [['POST', /^login$/]],
        revoke_routes: [['GET', /^logout$/]]
      }
    }

    before :each do
      Sphynx.configure do |config|
        config.dispatch_routes = [['POST', /^login$/]]
        config.revoke_routes = [['GET', /^logout$/]]
      end

      expect(Sphynx.configuration).to have_attributes(expected_config)
    end

    after :all do
      Sphynx.reset
    end

    describe '.configuration' do
      it 'should return the configuration object' do
        expect(Sphynx.configuration).to be_a(Sphynx::Configuration)
      end
    end

    describe '.reset' do
      it 'should reset configuration to default values' do
        Sphynx.reset

        expect(Sphynx.configuration).to have_attributes(dispatch_routes: [], revoke_routes: [])
      end
    end
  end
end
