RSpec.describe Sphynx::Configuration do
  let(:instance) { described_class.new }

  it 'should have default config values upon creation' do
    default_config = {
      dispatch_requests: [],
      revocation_requests: [],
      secret: nil,
      scopes: {
        user: {
          user_class: User,
          provider_class: AuthProvider,
          revocation_strategy: Sphynx::RevocationStrategies::NullStrategy
        }
      }
    }

    expect(instance).to have_attributes(default_config)
  end

  context 'when the default User class is not defined' do
    before(:all) { Object.send(:remove_const, :User) }
    after(:all) { load(__dir__ + '/../fixtures/user.rb') }

    it 'should not set a default value for scopes' do
      expect(instance.scopes).to be_nil
    end
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

    it 'should raise an error if one of the scope has no user_class' do
      scopes = {
        user: { user_class: User, provider_class: AuthProvider },
        admin: { provider_class: AuthProvider }
      }

      expect { instance.scopes = scopes }.to raise_error(ArgumentError)
    end

    it 'should raise an error if one of the scope has no provider_class' do
      scopes = {
        user: { user_class: User, provider_class: AuthProvider },
        admin: { user_class: User }
      }

      expect { instance.scopes = scopes }.to raise_error(ArgumentError)
    end

    it 'should set the scopes and set default revocation strategy for scopes that dont have one' do
      scopes = {
        user: { user_class: User, provider_class: AuthProvider },
        admin: { user_class: User, provider_class: AuthProvider, revocation_strategy: DummyRevocationStrategy }
      }

      expected_scopes = {
        user: { user_class: User, provider_class: AuthProvider, revocation_strategy: Sphynx::RevocationStrategies::NullStrategy },
        admin: { user_class: User, provider_class: AuthProvider, revocation_strategy: DummyRevocationStrategy }
      }

      instance.scopes = scopes

      expect(instance.scopes).to eq(expected_scopes)
    end
  end
end
