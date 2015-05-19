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
end
