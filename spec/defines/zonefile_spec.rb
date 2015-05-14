require 'spec_helper'

describe 'nsd::zonefile' do
  let(:title) { 'example.com' }
  let(:facts) { {:concat_basedir => '/tmp'} }

  context 'with sane defaults' do
    let(:params) { {
      :admin_email => 'admin@example.com',
      :serial_number => 1
    } }

    it { should contain_nsd__zonefile('example.com') }

    it do
      should contain_file('/etc/nsd/example.com.zone').with({
        'ensure' => 'present',
        'owner'  => 0,
        'group'  => 0,
        'mode'   => '0644',
      })
      .with_content(/admin\.example\.com\./)
    end
  end

  context 'with email address ending in period' do
    let(:params) { {
      :admin_email => 'admin@example.com.',
      :serial_number => 1
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
      :serial_number => 1
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /Admin email address is invalid\./)
    end
  end
end

at_exit { RSpec::Puppet::Coverage.report! }
