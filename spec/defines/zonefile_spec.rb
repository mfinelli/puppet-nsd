require 'spec_helper'

describe 'nsd::zonefile' do
  let(:title) { 'example.com' }
  let(:facts) { {:concat_basedir => '/tmp'} }

  context 'with sane defaults' do
    let(:params) { {
      :admin_email => 'admin@example.com',
      :serial_number => 1,
      :nameservers => ['ns1.example.com.']
    } }

    it { should contain_nsd__zonefile('example.com') }

    it do
      should contain_file('/etc/nsd/example.com.zone').with({
        'ensure' => 'present',
        'owner'  => 0,
        'group'  => 0,
        'mode'   => '0644',
      })

      should contain_file('/etc/nsd/example.com.zone')
        .with_content(/\$ORIGIN example\.com\./)
      should contain_file('/etc/nsd/example.com.zone')
        .with_content(/admin\.example\.com\./)
      should contain_file('/etc/nsd/example.com.zone')
        .with_content(/@ IN SOA ns1\.example\.com\./)
    end
  end

  context 'with email address ending in period' do
    let(:params) { {
      :admin_email => 'admin@example.com.',
      :serial_number => 1,
      :nameservers => ['ns1.example.com.']
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
        /The admin email address shouldn't end in a full stop\./)
    end
  end

  context 'with invalid email address' do
    let(:params) { {
      :admin_email => 'not.an.email.address',
      :serial_number => 1,
      :nameservers => ['ns1.example.com.']
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /Admin email address is invalid\./)
    end
  end

  context 'with nameservers not an array' do
    let(:params) { {
      :admin_email => 'admin@example.com',
      :serial_number => 1,
      :nameservers => 'ns1.example.com.'
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /"ns1.example.com." is not an Array/)
    end
  end

  context 'with no nameservers' do
    let(:params) { {
      :admin_email => 'admin@example.com',
      :serial_number => 1,
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
          /You must specify at least one nameserver./)
    end
  end

  context 'with first nameserver not ending in a full stop' do
    let(:params) { {
      :admin_email => 'admin@example.com',
      :serial_number => 1,
      :nameservers => ['ns1.example.com', 'ns2.example.com.']
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
          /All nameservers must end in a full stop./)
    end
  end

  context 'with second nameserver not ending in a full stop' do
    let(:params) { {
      :admin_email => 'admin@example.com',
      :serial_number => 1,
      :nameservers => ['ns1.example.com.', 'ns2.example.com']
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
          /All nameservers must end in a full stop./)
    end
  end

  context 'with two valid nameservers' do
    let(:params) { {
      :admin_email => 'admin@example.com',
      :serial_number => 1,
      :nameservers => ['ns1.example.com.', 'ns2.example.com.']
    } }

    it do
      should contain_file('/etc/nsd/example.com.zone')
        .with_content(/NS ns1\.example\.com\./)
        .with_content(/NS ns2\.example\.com\./)
    end
  end
end

at_exit { RSpec::Puppet::Coverage.report! }
