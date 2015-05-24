# Beaker class: nsd::remote
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
require 'spec_helper_acceptance'

describe 'nsd::remote' do

  context 'with managed server key' do
    it 'should manage the file' do
      pp = <<-EOS
        include '::nsd'
        class { '::nsd::remote':
          server_key_manage  => true,
          server_key_file    => 'file:///root/server.key'
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    describe file('/etc/nsd/nsd_server.key') do
      it { should be_file }
      it { should contain '# server key for spec testing' }
    end
  end

  context 'with managed server cert' do
    it 'should manage the file' do
      pp = <<-EOS
        include '::nsd'
        class { '::nsd::remote':
          server_cert_manage  => true,
          server_cert_file    => 'file:///root/server.cert'
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    describe file('/etc/nsd/nsd_server.pem') do
      it { should be_file }
      it { should contain '# server cert for spec testing' }
    end
  end

  context 'with managed control key' do
    it 'should manage the file' do
      pp = <<-EOS
        include '::nsd'
        class { '::nsd::remote':
          control_key_manage  => true,
          control_key_file    => 'file:///root/control.key'
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    describe file('/etc/nsd/nsd_control.key') do
      it { should be_file }
      it { should contain '# control key for spec testing' }
    end
  end

  context 'with managed control cert' do
    it 'should manage the file' do
      pp = <<-EOS
        include '::nsd'
        class { '::nsd::remote':
          control_cert_manage  => true,
          control_cert_file    => 'file:///root/control.cert'
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    describe file('/etc/nsd/nsd_control.pem') do
      it { should be_file }
      it { should contain '# control cert for spec testing' }
    end
  end

end
