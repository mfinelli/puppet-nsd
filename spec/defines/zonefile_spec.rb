require 'spec_helper'

describe 'nsd::zonefile' do
  let(:title) { 'example.com' }

  it { should contain_class('nsd::zonefile') }

  it do
    should contain_file('/etc/nsd/example.com.zone').with({
      'ensure' => 'present',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
  end

  context 'with valid admin email address' do
    let(:params) { {:admin_email => 'admin@example.com'} }

    it do
      should contain_file('/etc/nsd/example.com.zone')
        .with_content(/admin\.example\.com\./)
    end
  end

  context 'with email address ending in period' do
    let(:params) { {:admin_email => 'admin@example.com.'} }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
        /The admin email address should't end in a period\./)
    end
  end

  context 'with invalid email address' do
    let(:params) { {:admin_email => 'not.an.email.address'} }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /Admin email address is invalid\./)
    end
  end
end

at_exit { RSpec::Puppet::Coverage.report! }
