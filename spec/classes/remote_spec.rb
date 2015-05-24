# Rspec class: nsd::remote
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

describe 'nsd::remote' do

  let(:facts) { {:concat_basedir => '/tmp'} }

  context 'with defaults' do
    it do
      should contain_concat__fragment('nsd-remote')
                 .with_content(/remote\-control:/)
                 .with_content(/control\-enable: yes/)
    end
  end

  context 'with non-default values' do
    let(:params) { {
        :port => 2222,
        :interface => ['127.0.0.2', '127.0.0.3']
    } }

    it do
      should contain_concat__fragment('nsd-remote')
                 .with_content(/control\-port: 2222/)
                 .with_content(/control\-interface: 127\.0\.0\.2/)
                 .with_content(/control\-interface: 127\.0\.0\.3/)
    end
  end

  context 'with non-array interface' do
    let(:params) { {
        :interface => '127.0.0.5'
    } }

    it do
      should contain_concat__fragment('nsd-remote')
                 .with_content(/control\-interface: 127\.0\.0\.5/)
    end
  end

  context 'with garbage interfaces' do
    let(:params) { {
        :interface => ['127.0.0.7', 'not.an.ip.addr']
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error,
                       /"not\.an\.ip\.addr" is not a valid IP address/)
    end
  end

  context 'with non-integer port' do
    let(:params) { {
        :port => 'port'
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error,
                       /Expected first argument to be an Integer/)
    end
  end

  context 'with remote explicitly disabled' do
    let(:params) { {
        :enable => false
    } }

    it do
      should contain_concat__fragment('nsd-remote')
                 .without_content(/remote\-control:/)
    end
  end

  context 'with enable not a boolean' do
    let(:params) { {
        :enable => 'no'
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error, /"no" is not a boolean/)
    end
  end

  context 'with server key manage not a boolean' do
    let(:params) { {
        :server_key_manage => 'no'
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error, /"no" is not a boolean/)
    end
  end

  context 'with server cert manage not a boolean' do
    let(:params) { {
        :server_cert_manage => 'no'
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error, /"no" is not a boolean/)
    end
  end

  context 'with control key manage not a boolean' do
    let(:params) { {
        :control_key_manage => 'no'
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error, /"no" is not a boolean/)
    end
  end

  context 'with control cert manage not a boolean' do
    let(:params) { {
        :control_cert_manage => 'no'
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error, /"no" is not a boolean/)
    end
  end

  context 'with server key manage true and file undefined' do
    let(:params) { {
        :server_key_manage => true
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error,
                       /You must specify a source to manage the server key/)
    end
  end

  context 'with server cert manage true and file undefined' do
    let(:params) { {
        :server_cert_manage => true
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error,
                       /You must specify a source to manage the server cert/)
    end
  end

  context 'with control key manage true and file undefined' do
    let(:params) { {
        :control_key_manage => true
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error,
                       /You must specify a source to manage the control key/)
    end
  end

  context 'with control cert manage true and file undefined' do
    let(:params) { {
        :control_cert_manage => true
    } }

    it do
      expect {
        should contain_concat__fragment('nsd-remote')
      }.to raise_error(Puppet::Error,
                       /You must specify a source to manage the control cert/)
    end
  end

  context 'with server key management' do
    let(:params) { {
        :server_key_manage => true,
        :server_key_file => 'puppet:///modules/nsd/server.key'
    } }

    it do
      should contain_file('/etc/nsd/nsd_server.key')
                 .with(
                     {
                         'ensure' => 'present',
                         'owner' => 0,
                         'group' => 0,
                         'mode' => '0640',
                     }
                 )
    end
  end

  context 'with server cert management' do
    let(:params) { {
        :server_cert_manage => true,
        :server_cert_file => 'puppet:///modules/nsd/server.cert'
    } }

    it do
      should contain_file('/etc/nsd/nsd_server.pem')
                 .with(
                     {
                         'ensure' => 'present',
                         'owner' => 0,
                         'group' => 0,
                         'mode' => '0640',
                     }
                 )
    end
  end

  context 'with control key management' do
    let(:params) { {
        :control_key_manage => true,
        :control_key_file => 'puppet:///modules/nsd/control.key'
    } }

    it do
      should contain_file('/etc/nsd/nsd_control.key')
                 .with(
                     {
                         'ensure' => 'present',
                         'owner' => 0,
                         'group' => 0,
                         'mode' => '0640',
                     }
                 )
    end
  end

  context 'with control cert management' do
    let(:params) { {
        :control_cert_manage => true,
        :control_cert_file => 'puppet:///modules/nsd/control.cert'
    } }

    it do
      should contain_file('/etc/nsd/nsd_control.pem')
                 .with(
                     {
                         'ensure' => 'present',
                         'owner' => 0,
                         'group' => 0,
                         'mode' => '0640',
                     }
                 )
    end
  end

end
