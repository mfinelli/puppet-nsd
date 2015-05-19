# Rspec define: nsd::zonefile
#
# This file is part of the test suite for the nsd module.
#
# === Authors
#
# Mario Finelli <mario@finel.li>
#
# === Copyright
#
# Copyright 2015 Mario Finelli
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
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
      should contain_file('/etc/nsd/example.com.zone')
                 .with(
                     {
                         'ensure' => 'present',
                         'owner' => 0,
                         'group' => 0,
                         'mode' => '0644',
                     }
                 )

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
                       /The admin email address shouldn't end in a full stop/)
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

  # We can only test these values using new lambda functions from puppet 4.0
  # We'll save adding these tests for later...
  # if ENV.key?('PUPPET_VERSION') and ENV['PUPPET_VERSION'].to_f >= 4.0
  #   context 'with first nameserver not ending in a full stop' do
  #     let(:params) { {
  #       :admin_email => 'admin@example.com',
  #       :serial_number => 1,
  #       :nameservers => ['ns1.example.com', 'ns2.example.com.']
  #     } }
  #
  #     it do
  #       expect {
  #         should contain_file('/etc/nsd/example.com.zone')
  #       }.to raise_error(Puppet::Error,
  #           /All nameservers must end in a full stop./)
  #     end
  #   end
  #
  #   context 'with second nameserver not ending in a full stop' do
  #     let(:params) { {
  #       :admin_email => 'admin@example.com',
  #       :serial_number => 1,
  #       :nameservers => ['ns1.example.com.', 'ns2.example.com']
  #     } }
  #
  #     it do
  #       expect {
  #         should contain_file('/etc/nsd/example.com.zone')
  #       }.to raise_error(Puppet::Error,
  #           /All nameservers must end in a full stop./)
  #     end
  #   end
  # end

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

  context 'with time to live not an integer' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :ttl => 'ttl'
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
                       /Expected first argument to be an Integer/)
    end
  end

  context 'with time to live as a string integer' do
    if (ENV.key?('PUPPET_VERSION') and ENV['PUPPET_VERSION'].to_f >= 4.0) or
        (ENV.key?('FUTURE_PARSER') and ENV['FUTURE_PARSER'] == 'yes')
      let(:params) { {
          :admin_email => 'admin@example.com',
          :serial_number => 1,
          :nameservers => ['ns1.example.com.'],
          :ttl => '1'
      } }

      it do
        expect {
          should contain_file('/etc/nsd/example.com.zone')
        }.to raise_error(Puppet::Error,
                         /A String is not comparable to a non String/)
      end
    end
  end

  context 'with time to live negative' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :ttl => -10
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /Time to live must be positive./)
    end
  end

  context 'with refresh not an integer' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :refresh => 'refresh'
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
                       /Expected first argument to be an Integer/)
    end
  end

  context 'with refresh as a string integer' do
    if (ENV.key?('PUPPET_VERSION') and ENV['PUPPET_VERSION'].to_f >= 4.0) or
        (ENV.key?('FUTURE_PARSER') and ENV['FUTURE_PARSER'] == 'yes')
      let(:params) { {
          :admin_email => 'admin@example.com',
          :serial_number => 1,
          :nameservers => ['ns1.example.com.'],
          :refresh => '1'
      } }

      it do
        expect {
          should contain_file('/etc/nsd/example.com.zone')
        }.to raise_error(Puppet::Error,
                         /A String is not comparable to a non String/)
      end
    end
  end

  context 'with refresh negative' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :refresh => -10
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /Refresh value must be positive./)
    end
  end

  context 'with retry not an integer' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :retry => 'retry'
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
                       /Expected first argument to be an Integer/)
    end
  end

  context 'with retry as a string integer' do
    if (ENV.key?('PUPPET_VERSION') and ENV['PUPPET_VERSION'].to_f >= 4.0) or
        (ENV.key?('FUTURE_PARSER') and ENV['FUTURE_PARSER'] == 'yes')
      let(:params) { {
          :admin_email => 'admin@example.com',
          :serial_number => 1,
          :nameservers => ['ns1.example.com.'],
          :retry => '1'
      } }

      it do
        expect {
          should contain_file('/etc/nsd/example.com.zone')
        }.to raise_error(Puppet::Error,
                         /A String is not comparable to a non String/)
      end
    end
  end

  context 'with retry negative' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :retry => -10
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /Retry value must be positive./)
    end
  end

  context 'with expire not an integer' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :expire => 'expire'
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error,
                       /Expected first argument to be an Integer/)
    end
  end

  context 'with expire as a string integer' do
    if (ENV.key?('PUPPET_VERSION') and ENV['PUPPET_VERSION'].to_f >= 4.0) or
        (ENV.key?('FUTURE_PARSER') and ENV['FUTURE_PARSER'] == 'yes')
      let(:params) { {
          :admin_email => 'admin@example.com',
          :serial_number => 1,
          :nameservers => ['ns1.example.com.'],
          :expire => '1'
      } }

      it do
        expect {
          should contain_file('/etc/nsd/example.com.zone')
        }.to raise_error(Puppet::Error,
                         /A String is not comparable to a non String/)
      end
    end
  end

  context 'with expire negative' do
    let(:params) { {
        :admin_email => 'admin@example.com',
        :serial_number => 1,
        :nameservers => ['ns1.example.com.'],
        :expire => -10
    } }

    it do
      expect {
        should contain_file('/etc/nsd/example.com.zone')
      }.to raise_error(Puppet::Error, /Expire value must be positive./)
    end
  end
end
