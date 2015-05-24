# Rspec function: validate_nameserver
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

describe 'the validate_nameserver function' do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('validate_nameserver'))
        .to eq('function_validate_nameserver')
  end

  it 'should raise a ParseError if there is less than 1 arguments' do
    expect { scope.function_validate_nameserver([]) }
        .to(raise_error(Puppet::ParseError))
  end

  it 'should raise a ParseError if there is more than 1 arguments' do
    expect { scope.function_validate_nameserver(%w(foo bar)) }
        .to(raise_error(Puppet::ParseError))
  end

  it 'should raise a ParseError if not given an array' do
    expect { scope.function_validate_nameserver(%w('foo')) }
        .to(raise_error(Puppet::ParseError))
  end
end
