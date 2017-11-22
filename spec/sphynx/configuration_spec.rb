require 'spec_helper'

RSpec.describe Sphynx::Configuration do
  let(:instance) { described_class.new }

  it 'should have default config values upon creation' do
    default_config = {
      dispatch_routes: [],
      revoke_routes: []
    }

    expect(instance).to have_attributes(default_config)
  end

  describe '#dispatch_routes=' do
    it 'should raise an error if arguments are not valid' do
      expect { instance.dispatch_routes = 'invalid params' }.to raise_error(ArgumentError)
      expect { instance.dispatch_routes = ['invalid params'] }.to raise_error(ArgumentError)
      expect { instance.dispatch_routes = [['VERB', /^login$/]] }.to raise_error(ArgumentError)
      expect { instance.dispatch_routes = [['POST', 'login']] }.to raise_error(ArgumentError)
    end

    it 'should set the config key when arguments are valid' do
      expect { instance.dispatch_routes = [['POST', /^login$/]] }.not_to raise_error
      expect(instance.dispatch_routes).to eq([['POST', /^login$/]])
    end
  end

  describe '#revoke_routes=' do
    it 'should raise an error if arguments are not valid' do
      expect { instance.revoke_routes = 'invalid params' }.to raise_error(ArgumentError)
      expect { instance.revoke_routes = ['invalid params'] }.to raise_error(ArgumentError)
      expect { instance.revoke_routes = [['VERB', /^login$/]] }.to raise_error(ArgumentError)
      expect { instance.revoke_routes = [['POST', 'login']] }.to raise_error(ArgumentError)
    end

    it 'should set the config key when arguments are valid' do
      expect { instance.revoke_routes = [['GET', /^logout$/]] }.not_to raise_error
      expect(instance.revoke_routes).to eq([['GET', /^logout$/]])
    end
  end
end
