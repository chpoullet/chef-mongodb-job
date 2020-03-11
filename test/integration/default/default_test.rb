# InSpec test for recipe mongodb_cookbook::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end


describe package ('mongodb-org') do
  its('version') { should cmp > '3.2.*'}
end

describe service "mongod" do
  it { should be_running }
  it { should be_enabled }
end

describe port('0.0.0.0', 27017) do
  it { should be_listening }
end
