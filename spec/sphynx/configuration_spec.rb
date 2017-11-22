require 'spec_helper'

RSpec.describe Sphynx::Configuration do
  let(:instance) { described_class.new }

  it 'should have default config values upon creation' do
    default_config = {
      dispatch_requests: [],
      revocation_requests: [],
      secret: nil,
      scopes: {
        user: {
          repository: User,
          revocation_strategy: Sphynx::RevocationStrategies::NullStrategy
        }
      }
    }

    expect(instance).to have_attributes(default_config)
  end

  describe 'request setter methods' do
    %i[dispatch_requests revocation_requests].each do |setter|
      describe "##{setter}=" do
        it 'should raise an error if arguments are not valid' do
          expect { instance.send("#{setter}=", 'invalid params') }.to raise_error(ArgumentError)
          expect { instance.send("#{setter}=", ['invalid params']) }.to raise_error(ArgumentError)
          expect { instance.send("#{setter}=", [['VERB', /^login$/]]) }.to raise_error(ArgumentError)
          expect { instance.send("#{setter}=", [['POST', 'login']]) }.to raise_error(ArgumentError)
        end

        it 'should set the config key when arguments are valid' do
          expect { instance.send("#{setter}=", [['POST', /^login$/]]) }.not_to raise_error
          expect(instance.send(setter)).to eq([['POST', /^login$/]])
        end
      end
    end
  end

  describe '#scopes=' do
    it 'should raise an error if there is no provided scope' do
      expect { instance.scopes = '' }.to raise_error(ArgumentError)
      expect { instance.scopes = {} }.to raise_error(ArgumentError)
    end

    it 'should raise an error if one of the scope has no repository' do
      scopes = {
        user: { repository: User },
        admin: {}
      }

      expect { instance.scopes = scopes }.to raise_error(ArgumentError)
    end

    it 'should set the scopes and set default revocation strategy for scopes that dont have one' do
      scopes = {
        user: { repository: User },
        admin: { repository: User, revocation_strategy: DummyRevocationStrategy }
      }

      expected_scopes = {
        user: { repository: User, revocation_strategy: Sphynx::RevocationStrategies::NullStrategy },
        admin: { repository: User, revocation_strategy: DummyRevocationStrategy }
      }

      instance.scopes = scopes

      expect(instance.scopes).to eq(expected_scopes)
    end
  end
end